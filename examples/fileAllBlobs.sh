# fileAllBlobs.sh ... row after row extract BLOBs from single column and write them to files named by a key field and row number 
# autogenerated Wed Nov 23 19:38:29 MST 2016 by jwoehr using command:
# gensh -to fileAllBlobs.sh -path /opt/ublu/ublu.jar -optr s SERVER @myServer ${ Server }$ -optr l LIBRARY @myLib ${ Library }$ -optr t TABLE @myTable ${ Table }$ -optr u USER @myUser ${ User }$ -optr p PASSWORD @password ${ Password }$ -optr n NAMECOLUMN @myNameCol ${ Label of column for most key-like string used as output file component }$ -optr b BLOBCOLUMN @myBlobCol ${ Label of column containing BLOB }$ -optr f FIRSTROW @myFirstRow ${ One's-based number of first row to process }$ ${ fileAllBlobs.sh ... row after row extract BLOBs from single column and write them to files named by a key field and row number }$ /opt/ublu/examples/fileAllBlobs.ublu ${ fileAllBlobs ( @myServer @myLib @myTable @myUser @password @myNameCol @myBlobCol @myFirstRow ) }$

# Usage message
function usage {
echo "fileAllBlobs.sh ... row after row extract BLOBs from single column and write them to files named by a key field and row number "
echo "This shell script was autogenerated Wed Nov 23 19:38:29 MST 2016 by jwoehr."
echo "Usage: $0 [silent] -h -s SERVER -l LIBRARY -t TABLE -u USER -p PASSWORD -n NAMECOLUMN -b BLOBCOLUMN -f FIRSTROW "
echo "	where"
echo "	-h		display this help message and exit 0"
echo "	-s SERVER	Server  (required option)"
echo "	-l LIBRARY	Library  (required option)"
echo "	-t TABLE	Table  (required option)"
echo "	-u USER	User  (required option)"
echo "	-p PASSWORD	Password  (required option)"
echo "	-n NAMECOLUMN	Label of column for most key-like string used as output file component  (required option)"
echo "	-b BLOBCOLUMN	Label of column containing BLOB  (required option)"
echo "	-f FIRSTROW	One's-based number of first row to process  (required option)"
echo "---"
echo "If the keyword 'silent' appears ahead of all options, then included files will not echo and prompting is suppressed."
echo "Exit code is the result of execution, or 0 for -h or 2 if there is an error in processing options"
}

#Test if user wants silent includes
if [ "$1" == "silent" ]
then
	SILENT="-silent "
	shift
else
	SILENT=""
fi

# Process options
while getopts s:l:t:u:p:n:b:f:h the_opt
do
	case "$the_opt" in
		s)	SERVER="$OPTARG";;
		l)	LIBRARY="$OPTARG";;
		t)	TABLE="$OPTARG";;
		u)	USER="$OPTARG";;
		p)	PASSWORD="$OPTARG";;
		n)	NAMECOLUMN="$OPTARG";;
		b)	BLOBCOLUMN="$OPTARG";;
		f)	FIRSTROW="$OPTARG";;
		h)	usage;exit 0;;
		[?])	usage;exit 2;;

	esac
done
shift `expr ${OPTIND} - 1`
if [ $# -ne 0 ]
then
	echo "Superfluous argument(s) $*"
	usage
	exit 2
fi

# Translate options to tuple assignments
if [ "${SERVER}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myServer -trim \${ ${SERVER} }$ "
else
	echo "Option -s SERVER is a required option but is not present."
	usage
	exit 2
fi
if [ "${LIBRARY}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myLib -trim \${ ${LIBRARY} }$ "
else
	echo "Option -l LIBRARY is a required option but is not present."
	usage
	exit 2
fi
if [ "${TABLE}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myTable -trim \${ ${TABLE} }$ "
else
	echo "Option -t TABLE is a required option but is not present."
	usage
	exit 2
fi
if [ "${USER}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myUser -trim \${ ${USER} }$ "
else
	echo "Option -u USER is a required option but is not present."
	usage
	exit 2
fi
if [ "${PASSWORD}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @password -trim \${ ${PASSWORD} }$ "
else
	echo "Option -p PASSWORD is a required option but is not present."
	usage
	exit 2
fi
if [ "${NAMECOLUMN}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myNameCol -trim \${ ${NAMECOLUMN} }$ "
else
	echo "Option -n NAMECOLUMN is a required option but is not present."
	usage
	exit 2
fi
if [ "${BLOBCOLUMN}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myBlobCol -trim \${ ${BLOBCOLUMN} }$ "
else
	echo "Option -b BLOBCOLUMN is a required option but is not present."
	usage
	exit 2
fi
if [ "${FIRSTROW}" != "" ]
then
	gensh_runtime_opts="${gensh_runtime_opts}string -to @myFirstRow -trim \${ ${FIRSTROW} }$ "
else
	echo "Option -f FIRSTROW is a required option but is not present."
	usage
	exit 2
fi

# Invocation
java -jar /opt/ublu/ublu.jar ${gensh_runtime_opts} include ${SILENT}/opt/ublu/examples/fileAllBlobs.ublu fileAllBlobs \( @myServer @myLib @myTable @myUser @password @myNameCol @myBlobCol @myFirstRow \) 
exit $?
