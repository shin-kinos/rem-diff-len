
using TOML 

function get_fasta_info( input_filename )

    line = readlines( input_filename )

    i = 1
    while i ≤ length( line )
        if line[ i ][ begin ] == '>'
            push!( title_list, line[ i ] )
            push!( seq_list, line[ i + 1 ] )
            i += 1
        else
            seq_list[ end ] *= line[ i ]
        end
        i += 1
    end

end

function check_query_exist( query_title, input_filename )

    query_length = -1
    for i = 1 : length( title_list )
        if ( title_list )[ i ]  == query_title
            query_length = length( seq_list[ i ] )
            println( "\nQuery sequence :" )
            println( query_title, " (", query_length, " AA)" )
            break
        end
    end

    if query_length == -1
        println( "ERROR !" )
        println( "The query sequence does not exist in '", input_filename, " ' : " )
        println( query_title )
        println( "Program halted !!!" )
        exit( 1 )
    end

    return query_length

end

function check_threshold( short_threshold, long_threshold )

    if !( 0 ≤ short_threshold ≤ 1 )
        println( "ERROR !" )
        println( "Lower sequence length threshold must be bounded with a range of zero to one." )
        println( "Program halted !!!" )
        exit( 1 )
    end

    if !( long_threshold ≥ 1 )
        println( "ERROR !" )
        println( "Upper sequence length threshold must be more than one." )
        println( "Program halted !!!" )
        exit( 1 )
    end

end

function remove_short_long( short_length, long_length )

    println( "\nRemoved sequences : " )
    println( "Shorter than ", short_length, " AA or longer than ", long_length, " AA.\n" )

    for i = 1 : length( title_list )
        if length( seq_list[ i ] ) < short_length || long_length < length( seq_list[ i ] )
            println( title_list[ i ], " (",  length( seq_list[ i ] ), " AA)" )
        else
            push!( output_seq_list, seq_list[ i ] )
            push!( output_title_list, title_list[ i ] )
        end
    end

end

function save_result( output_filename )

    open( output_filename, "w") do fout

        for i = 1 : length( output_title_list )
            write( fout, output_title_list[ i ], "\n" )
            for j = 1 : length( output_seq_list[ i ] )
                if j % 60 == 0
                    write( fout, output_seq_list[ i ][ j ], "\n" )
                else 
                    write( fout, output_seq_list[ i ][ j ] )
                end
            end
            if length( output_seq_list[ i ] ) % 60 != 0
                write( fout, "\n")
            end
        end

    end;

    println( "\n'", output_filename, "' was correctly written.\n" )
end

println( "\nRemove too short and too long sequences compared to the query sequence in MSA.\n" )

# Check the number of arguments.
if length( ARGS ) != 1
    println( "Only one argument, input filename." )
    exit( 1 )
end

seq_list          = []
title_list        = []
output_seq_list   = []
output_title_list = []

# Read TOML file and get input information.
input = read( ARGS[ 1 ], String )
#println( input )
toml_data = TOML.parse( input )

input_filename  = toml_data[ "file" ][ "input" ][ "name" ]
output_filename = toml_data[ "file" ][ "output" ][ "name" ]
query_title     = toml_data[ "query" ][ "title" ]
short_threshold = toml_data[ "threshold" ][ "short" ][ "value" ]
long_threshold  = toml_data[ "threshold" ][ "long" ][ "value" ]

# Read Multi-FASTA file and get sequence information.
get_fasta_info( input_filename )

# Check whether or not the query sequence exists in MSA.
query_length = check_query_exist( query_title, input_filename )

# Check thresholds are correct. 
check_threshold( short_threshold, long_threshold )

short_length = Int( floor( query_length * short_threshold ) )
long_length  = Int( floor( query_length * long_threshold ) )

# Remove too short and long sequences.
remove_short_long( short_length, long_length )

# Save result.
save_result( output_filename )

println( "Program completed !!!" )
