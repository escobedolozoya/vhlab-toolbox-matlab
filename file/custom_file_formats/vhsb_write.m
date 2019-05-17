b = vhsb_write(fo, x, y, varargin)
% VHSB_WRITE - write a VHLab series binary file
%
% B = VHSB_WRITE(FO, X, Y, ...)
%
% Write series data to a VH series binary file.
%
% Inputs:
%    FO is the file description to write to; it can be a 
%         filename or an object of type FILEOBJ
%    X is a NUMSAMPLESx1 dataset, usually the independent variable.
%         X can be empty if an X_start and X_increment are provided
%    Y is an NUM_SAMPLESxXxYxZx... dataset with the Y samples that
%         are associated with each value of X.
%         X(i) is the ith sample of X, and Y(i,:,:,...) is the ith sample of Y
%         
% Outputs: 
%    B is 1 if the file was written successfully, 0 otherwise
% 
% The function accepts parameters that modify the default functionality
% as name/value pairs.
% Parameter (default)                           | Description
% ------------------------------------------------------------------------------
% use_filelock (1)                              | Lock the file with CHECKOUT_LOCK_FILE
% X_start (X(1))                                | The value of X in the first sample
% X_increment (0)                               | The increment between subsequent values of X
%                                               |    (needs only be non-zero if X_constantinterval is 1)
% X_stored (1)                                  | Should values of X be stored (1), or computed from X_start
%                                               |    and X_increment (0)?
% X_constantinterval (0)                        | Is there a constant interval between X samples (1) or not (0) or
%                                               |    not necessarily (0)?
% X_units ('')                                  | The units of X (a character string, up to 255 characters)
% Y_units ('')                                  | The units of Y (a character string, up to 255 characters)
% X_data_size (64)                              | The resolution (in bytes) for X
% X_data_type ('float')                         | The data type to be written for X ('char','uint','int','float')
% Y_data_size (64)                              | The resolution (in bytes) for Y
% Y_data_type ('float')                         | The data type to be written for Y ('char','uint','int','float')
% X_usescale (0)                                | Scale the X data before writing to disk (and after reading)?
% Y_usescale (0)                                | Scale the Y data before writing to disk (and after reading)?
% X_scale (1)                                   | The X scale factor to use to write samples to disk
% X_offset (0)                                  | The X offset to use (Xdisk = X/X_scale + X_offset)
% Y_scale (1)                                   | The Y scale factor to use
% Y_offset (0)                                  | The Y offset to use (Ydisk = Y/Y_scale + X_offset)
%
% See also: NAMEVALUEPAIR 
%
%

use_filelock = 1;

X_start = x(1);
X_increment = 0;
X_stored = 1;
X_constantinterval = 0;
X_units = '';
Y_units = '';
X_data_size = 64;
X_data_type = 'float';
Y_data_size = 64;
Y_data_type = 'float';
X_usescale = 0;
Y_usescale = 0;
X_scale = 1;
X_offset = 0;
Y_scale = 1;
Y_offset = 0;
Y_dim = size(y); error('check this');

assign(varargin{:});

if X_usescale,
	x = x/X_scale + X_offset;
end;
if Y_usescale,
	y = y/Y_scale + Y_offset;
end;

switch lower(X_data_type),
	case 'char',
		X_data_type = 1;
	case 'uint',
		X_data_type = 2;
	case 'int',
		X_data_type = 3;
	case 'float',
		X_data_type = 4;
	otherwise,
		error(['Unknown datatype ' X_data_type '.']);
end;

switch Y_data_type,
	case 'char',
		Y_data_type = 1;
	case 'uint',
		Y_data_type = 2;
	case 'int',
		Y_data_type = 3;
	case 'float',
		Y_data_type = 4;
	otherwise,
		error(['Unknown datatype ' Y_data_type '.']);
end;

parameters = workspace2struct;
parameters = rmfield(parameters,{'x','y','use_filelock'});

if use_filelock,
	lock_fname = [filename_value(fo) '-lock'];
	fid = checkout_lock_file(lock_fname);
	if fid<0,
		error(['Could not get lock for file ' lock_fname '.']);
	end;
end;

h=vhsb_writeheader(fo,struct2namevaluepair(parameters));
 % vhsb_writeheader will close the file
fo = fopen(fo,'w','ieee-le');

fseek(fo,h.headsize,'bof');

 % write X

X_skip_bytes = prod(Y_dim) * Y_data_size;

fwrite(fo,x,vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size),X_skip_bytes);

Y_skip_bytes = X_data_size;

fwrite(fo,reshape(y,1,prod(Y_dim)),vhsb_sampletype2matlabfwritestring(Y_data_type, Y_data_size),Y_skip_bytes);

if use_filelock,
	fclose(fid);
	delete(lock_fname);
end;
	
