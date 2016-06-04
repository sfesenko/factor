USING: alien.c-types alien.syntax classes.struct
windows.kernel32 windows.types ;
in: windows.directx.audiodefs

STRUCT: WAVEFORMATEX
    { wFormatTag      WORD  }
    { nChannels       WORD  }
    { nSamplesPerSec  DWORD }
    { nAvgBytesPerSec DWORD }
    { nBlockAlign     WORD  }
    { wBitsPerSample  WORD  }
    { cbSize          WORD  } ;

TYPEDEF: WAVEFORMATEX* PWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* NPWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* LPWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* PCWAVEFORMATEX ;
TYPEDEF: WAVEFORMATEX* LPCWAVEFORMATEX ;

UNION-STRUCT: WAVEFORMATEXTENSIBLE_UNION
    { wValidBitsPerSample WORD }
    { wSamplesPerBlock    WORD }
    { wReserved           WORD } ;

STRUCT: WAVEFORMATEXTENSIBLE
    { Format        WAVEFORMATEX               }
    { Union         WAVEFORMATEXTENSIBLE_UNION }
    { dwChannelMask DWORD                      }
    { SubFormat     GUID                       } ;

TYPEDEF: WAVEFORMATEXTENSIBLE* PWAVEFORMATEXTENSIBLE ;
TYPEDEF: WAVEFORMATEXTENSIBLE* LPWAVEFORMATEXTENSIBLE ;
TYPEDEF: WAVEFORMATEXTENSIBLE* PCWAVEFORMATEXTENSIBLE ;
TYPEDEF: WAVEFORMATEXTENSIBLE* LPCWAVEFORMATEXTENSIBLE ;

STRUCT: WAVEFORMAT
    { wFormatTag      WORD  }
    { nChannels       WORD  }
    { nSamplesPerSec  DWORD }
    { nAvgBytesPerSec DWORD }
    { nBlockAlign     WORD  } ;
TYPEDEF: WAVEFORMAT* PWAVEFORMAT ;
TYPEDEF: WAVEFORMAT* NPWAVEFORMAT ;
TYPEDEF: WAVEFORMAT* LPWAVEFORMAT ;

STRUCT: PCMWAVEFORMAT
    { wf             WAVEFORMAT }
    { wBitsPerSample WORD       } ;
TYPEDEF: PCMWAVEFORMAT* PPCMWAVEFORMAT ;
TYPEDEF: PCMWAVEFORMAT* NPPCMWAVEFORMAT ;
TYPEDEF: PCMWAVEFORMAT* LPPCMWAVEFORMAT ;

CONSTANT: WAVE_FORMAT_PCM 1 ;

STRUCT: ADPCMCOEFSET
    { iCoef1 short }
    { iCoef2 short } ;

STRUCT: ADPCMWAVEFORMAT
    { wfx              WAVEFORMATEX    }
    { wSamplesPerBlock WORD            }
    { wNumCoef         WORD            }
    { aCoef            ADPCMCOEFSET[7] } ;

CONSTANT: WAVE_FORMAT_ADPCM           2 ;
CONSTANT: WAVE_FORMAT_UNKNOWN         0 ;
CONSTANT: WAVE_FORMAT_IEEE_FLOAT      3 ;
CONSTANT: WAVE_FORMAT_MPEGLAYER3      0x0055 ;
CONSTANT: WAVE_FORMAT_DOLBY_AC3_SPDIF 0x0092 ;
CONSTANT: WAVE_FORMAT_WMAUDIO2        0x0161 ;
CONSTANT: WAVE_FORMAT_WMAUDIO3        0x0162 ;
CONSTANT: WAVE_FORMAT_WMASPDIF        0x0164 ;
CONSTANT: WAVE_FORMAT_EXTENSIBLE      0xFFFE ;

CONSTANT: SPEAKER_FRONT_LEFT            0x00000001 ;
CONSTANT: SPEAKER_FRONT_RIGHT           0x00000002 ;
CONSTANT: SPEAKER_FRONT_CENTER          0x00000004 ;
CONSTANT: SPEAKER_LOW_FREQUENCY         0x00000008 ;
CONSTANT: SPEAKER_BACK_LEFT             0x00000010 ;
CONSTANT: SPEAKER_BACK_RIGHT            0x00000020 ;
CONSTANT: SPEAKER_FRONT_LEFT_OF_CENTER  0x00000040 ;
CONSTANT: SPEAKER_FRONT_RIGHT_OF_CENTER 0x00000080 ;
CONSTANT: SPEAKER_BACK_CENTER           0x00000100 ;
CONSTANT: SPEAKER_SIDE_LEFT             0x00000200 ;
CONSTANT: SPEAKER_SIDE_RIGHT            0x00000400 ;
CONSTANT: SPEAKER_TOP_CENTER            0x00000800 ;
CONSTANT: SPEAKER_TOP_FRONT_LEFT        0x00001000 ;
CONSTANT: SPEAKER_TOP_FRONT_CENTER      0x00002000 ;
CONSTANT: SPEAKER_TOP_FRONT_RIGHT       0x00004000 ;
CONSTANT: SPEAKER_TOP_BACK_LEFT         0x00008000 ;
CONSTANT: SPEAKER_TOP_BACK_CENTER       0x00010000 ;
CONSTANT: SPEAKER_TOP_BACK_RIGHT        0x00020000 ;
CONSTANT: SPEAKER_RESERVED              0x7FFC0000 ;
CONSTANT: SPEAKER_ALL                   0x80000000 ;

CONSTANT: SPEAKER_MONO             0x00000004 ;
CONSTANT: SPEAKER_STEREO           0x00000003 ;
CONSTANT: SPEAKER_2POINT1          0x0000000B ;
CONSTANT: SPEAKER_SURROUND         0x00010007 ;
CONSTANT: SPEAKER_QUAD             0x00028003 ;
CONSTANT: SPEAKER_4POINT1          0x0002800B ;
CONSTANT: SPEAKER_5POINT1          0x0002800F ;
CONSTANT: SPEAKER_7POINT1          0x000280CF ;
CONSTANT: SPEAKER_5POINT1_SURROUND 0x0000060F ;
CONSTANT: SPEAKER_7POINT1_SURROUND 0x0002860F ;
