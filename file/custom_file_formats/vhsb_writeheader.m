function b = vhsb_writeheader(file_obj, varargin)
% VHSB_WRITEHEADER - write a VH Lab Series Binary file header
%
% B = VHSB_WRITEHEADER(FILE_OBJ_OR_FNAME, ...)
%
% Writes or re-writes the header portion of 
%
% This function takes name/value pairs that override the default functionality:
% Parameter (default)               | Description 
% -----------------------------------------------------------------------------------------
% version (1)                       | 32-bit integer describing version. Only 1 is allowed.
% machine_format ('little-endian')  | The machine format. The only value allowed is
%                                   |    'little_endian'.
% X_data_size (64)                  | 32-bit integer describing the size (in bytes) of each 
%                                   |    data point in the X series.
% X_data_type (4)                   | Character describing whether X type is char (1), uint (2), int (3), or float (4)
% Y_dim_length (2)                  | Character describing length of a vector that indicates dimensions of each Y datum
% Y_dim ([1 1])                     | 32-bit unsigned integer describing the rows, columns, etc of each Y datum
% Y_data_size (64)                  | 32-bit integer describing the size (in bytes) of each 
%                                   |    sample in the Y series.
% Y_data_type (4)                   | Character describing whether Y type is char (1), uint (2), int (3), or float (4)
% X_stored (1)                      | Character 0 or 1 describing whether the X value of the series
%                                   |    is stored in the file or just inferred from start and increment.
% X_constantinterval (0)            | Character 0 or 1 describing whether the X value of the series consists
%                                   |    of a value that is incremented by a constant interval for each sample
% X_start (0)                       | The value of the first X data sample (same size/type as X_data)
% X_increment (0)                   | The value of the increment (same size/type as X_data)
%                                   |
% X_units ('')                      | A 256 character string with the units of X (after any scaling)
% Y_units ('')                      | A 256 character string with the units of Y (after any scaling)
% 
% X_usescale (0)                    | Character 0/1 should we scale what is read in X using parameters below?
% Y_usescale (0)                    | Character 0/1 should we scale what is read in Y using parameters below?


% skip 200 bytes for future

skip = 200;

version = 1;             % uint32 version number

machine_format = 'little-endian';  %

X_data_size = 64;        % X_data_size
X_data_type = [1 2 3];   % uint, int, float

Y_data_size = 64;        % Y_data_size
Y_data_type = [1 2 3];   % uint, int, float

Y_dim_length = 2;
Y_dim = [1 1];

X_stored = 0;            % 0/1 are the stamps for the X data stored?
X_constantinterval = 0;  % 0/1 are the X values regularly sampled?
X_start = 0;             % the value of the first X data
X_increment = 0;         % the increment value 

X_units = '';            % 256 character string, units after any scaling
Y_units = '';            % 256 character string, units after any scaling

X_usescale = 0;          % perform an input/output scale for X? Output will be 64-bit float if so
Y_usescale = 0;          % perform an input/output scale for Y? Output will be 64-bit float if so

X_scale = 1;             % 64-bit float scale factor
X_offset = 0;            % 64-bit float offset factor common to all X info
Y_scale = 1;             % 64-bit float scale factor
Y_offset = 0;            % 64-bit float offset factor common to all Y info


