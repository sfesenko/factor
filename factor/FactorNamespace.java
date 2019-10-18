/* :folding=explicit:collapseFolds=1: */

/*
 * $Id$
 *
 * Copyright (C) 2003, 2004 Slava Pestov.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package factor;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.TreeMap;
import java.util.Iterator;
import java.util.Map;

/**
 * A namespace is a list of name/value bindings. A namespace can optionally
 * have a parent, and a bound object, in which case every public field of the
 * object will be accessible through the namespace. Additionally, static fields
 * from arbitrary classes can be imported into the namespace.
 */
public class FactorNamespace implements PublicCloneable, FactorObject
{
	private static FactorWord NULL = new FactorWord("( represent-f )");
	private static FactorWord CHECK_PARENT = new FactorWord("( check-parent )");

	public Object obj;
	private FactorNamespace parent;
	private Map words;
	private Class constraint;

	//{{{ createConstrainedNamespace() method
	/**
	 * Used for dictionary.
	 */
	public static FactorNamespace createConstrainedNamespace(
		Class constraint) throws Exception
	{
		FactorNamespace namespace = new FactorNamespace(null,null,null);
		namespace.constraint = constraint;
		return namespace;
	} //}}}

	//{{{ FactorNamespace constructor
	public FactorNamespace(FactorNamespace parent) throws Exception
	{
		this(parent,null,null);
	} //}}}

	//{{{ FactorNamespace constructor
	public FactorNamespace(FactorNamespace parent, Object obj) throws Exception
	{
		this(parent,null,obj);
	} //}}}

	//{{{ FactorNamespace constructor
	/**
	 * Cloning constructor.
	 */
	public FactorNamespace(FactorNamespace parent, Map words, Object obj)
		throws Exception
	{
		this.parent = parent;

		this.words = new TreeMap();

		// used by clone()
		if(words != null)
		{
			Iterator iter = words.entrySet().iterator();
			while(iter.hasNext())
			{
				Map.Entry entry = (Map.Entry)iter.next();
				Object key = entry.getKey();
				Object value = entry.getValue();
				if(!(value instanceof VarBinding))
					this.words.put(key,value);
			}
		}

		this.obj = obj;
	} //}}}

	//{{{ getNamespace() method
	public FactorNamespace getNamespace(FactorInterpreter interp)
	{
		return this;
	} //}}}

	//{{{ getParent() method
	public FactorNamespace getParent()
	{
		return parent;
	} //}}}

	//{{{ getThis() method
	/**
	 * Returns the object bound to this namespace, or null.
	 */
	public Object getThis()
	{
		return obj;
	} //}}}

	//{{{ importVars() method
	/**
	 * Defines a variable bound to a Java field.
	 */
	public void importVars(String clazz, Cons vars)
		throws Exception
	{
		Class clas = Class.forName(clazz);
		while(vars != null)
		{
			String field = (String)vars.car(String.class);
			vars = vars.next();
			String word = (String)vars.car(String.class);

			setVariable(word,new VarBinding(
				clas.getField(field),
				null));

			vars = vars.next();
		}
	} //}}}

	//{{{ getVariable() method
	public Object getVariable(String name) throws Exception
	{
		Object o = words.get(name);
		if(o instanceof VarBinding)
			return ((VarBinding)o).get();
		else if(o == NULL)
			return null;
		else if(o == CHECK_PARENT)
		{
			// we know this is not a field binding
			return parent == null ? null
				: parent.getVariable(name);
		}
		else if(o == null)
		{
			// lazily instantiate object field binding
			lazyFieldInit(name);
			return getVariable(name);
		}
		else
			return o;
	} //}}}

	//{{{ setVariable() method
	public void setVariable(String name, Object value)
		throws Exception
	{
		Object o = words.get(name);
		if(o instanceof VarBinding && !(value instanceof VarBinding))
			((VarBinding)o).set(value);
		else if(o == null)
		{
			// lazily instantiate object field binding
			lazyFieldInit(name);
			setVariable(name,value);
			return;
		}
		else if(value == null)
			words.put(name,NULL);
		else
		{
			if(constraint != null)
			{
				if(!constraint.isAssignableFrom(
					value.getClass()))
				{
					throw new FactorRuntimeException(
						"Can only store "
						+ constraint
						+ " in " + this);
				}
			}
			words.put(name,value);
		}
	} //}}}

	//{{{ lazyFieldInit() method
	private void lazyFieldInit(String name)
	{
		if(obj != null)
		{
			try
			{
				Field f = obj.getClass().getField(name);
				if(!Modifier.isStatic(f.getModifiers()))
				{
					words.put(name,new VarBinding(f,obj));
					return;
				}
			}
			catch(Exception e)
			{
			}
		}

		// not a field, don't check again
		words.put(name,CHECK_PARENT);
	} //}}}

	//{{{ initAllFields() method
	private void initAllFields()
	{
		if(obj != null)
		{
			try
			{
				Field[] fields = obj.getClass().getFields();
				for(int i = 0; i < fields.length; i++)
				{
					Field f = fields[i];
					if(Modifier.isStatic(f.getModifiers()))
						continue;
					words.put(f.getName(),
						new VarBinding(f,obj));
				}
			}
			catch(Exception e)
			{
			}
		}
	} //}}}

	//{{{ toVarValueList() method
	/**
	 * Returns a list of pairs of variable names, and their values.
	 */
	public Cons toVarValueList()
	{
		initAllFields();

		Cons first = null;
		Cons last = null;
		Iterator iter = words.entrySet().iterator();
		while(iter.hasNext())
		{
			Map.Entry entry = (Map.Entry)iter.next();
			Object value = entry.getValue();
			if(value == CHECK_PARENT)
				continue;
			else if(value == NULL)
				value = null;

			if(value instanceof VarBinding)
			{
				try
				{
					value = ((VarBinding)value).get();
				}
				catch(Exception e)
				{
				}
			}

			Cons cons = new Cons(new Cons(entry.getKey(),value)
				,null);
			if(first == null)
				first = last = cons;
			else
			{
				last.cdr = cons;
				last = cons;
			}
		}

		return first;
	} //}}}

	//{{{ VarBinding class
	/**
	 * This is messy.
	 */
	static class VarBinding
	{
		private Field field;
		private Object instance;

		VarBinding(Field field, Object instance)
			throws FactorRuntimeException
		{
			this.field = field;
			this.instance = instance;
		}

		Object get() throws Exception
		{
			return FactorJava.jvarGet(field,instance);
		}

		void set(Object value) throws Exception
		{
			FactorJava.jvarSet(field,instance,value);
		}
	} //}}}

	//{{{ toString() method
	public String toString()
	{
		if(obj == null)
		{
			return "Namespace #" + Integer.toString(hashCode(),16);
		}
		else
			return "Namespace: " + obj + " #" + hashCode();
	} //}}}

	//{{{ clone() method
	public FactorNamespace clone(Object rebind)
	{
		if(rebind.getClass() != obj.getClass())
			throw new RuntimeException("Cannot rebind to different type");

		try
		{
			return new FactorNamespace(parent,words,rebind);
		}
		catch(Exception e)
		{
			throw new InternalError();
		}
	} //}}}

	//{{{ clone() method
	public Object clone()
	{
		if(obj != null)
			throw new RuntimeException("Cannot clone namespace that's bound to an object");

		try
		{
			return new FactorNamespace(parent,new TreeMap(words),null);
		}
		catch(Exception e)
		{
			throw new InternalError();
		}
	} //}}}
}
