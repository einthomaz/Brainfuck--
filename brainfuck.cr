require "option_parser"
require "colorize"

class Brainfuck

    def initialize(code : String, register_ammount : Int32)
        @code = code
        @register_pointer = 0
        @instruction_pointer = 0
        @registers = Array(Int32).new
        register_ammount.times do |c|
            @registers << 0
        end
        @stored_val = 0
    end

    def stored_val
        @stored_val
    end

    def registers
        @registers
    end

    def pretty_print
        print "["
        @registers.each_with_index do |item, i|
            if(i == @register_pointer)
                print item.colorize(:red)
                if(i == @registers.size-1)
                    print "]"
                else
                    print ", "
                end
            else
                print item
                if(i == @registers.size-1)
                    print "]"
                else
                    print ", "
                end
            end
        end
        print "\n"
        print "Stored Value: "
        print @stored_val.colorize(:red)
        print "\n"
    end

    def instruction_pointer
        @instruction_pointer
    end

    def register_pointer
        @register_pointer
    end

    def code
        @code
    end

    def check_register_jump_right
        if(@register_pointer + 1 <= @registers.size)
            return true
        else
            puts "Error at position #{@instruction_pointer+1} : #{@code[@instruction_pointer]}"
            exit(1)
        end
    end

    def check_register_jump_left
        if(@register_pointer - 1 >= 0)
            return true
        else
            puts "Error at position #{@instruction_pointer+1} : #{@code[@instruction_pointer]}"
            exit(1)
        end
    end

    def check_substraction
        if(@registers[@register_pointer] - 1 >= 0)
            return true
        else
            puts "Error at position #{@instruction_pointer+1} : #{@code[@instruction_pointer..@instruction_pointer+4]}"
            puts "Register-Pointer #{@register_pointer+1}"
            puts "Register : #{@registers}"
            exit(1)
        end
    end

    def check_stored_jump_left
        if(@register_pointer - @stored_val >= 0)
            return true
        else
            puts "Error at position #{@instruction_pointer+1} : #{@code[@instruction_pointer]}"
            exit(1)
        end
    end

    def check_stored_jump_right
        if(@register_pointer + @stored_val >= 0)
            return true
        else
            puts "Error at position #{@instruction_pointer+1} : #{@code[@instruction_pointer]}"
            exit(1)
        end
    end

    def seek_loop_end
        temp_instruction_pointer = @instruction_pointer
        opened_loops = 1
        closed_loops = 0
        loop do
            temp_instruction_pointer += 1
            case @code[temp_instruction_pointer]
            when '['
                opened_loops += 1
            when ']'
                if(opened_loops != closed_loops)
                    closed_loops += 1
                end
            end
            temp_inst_is_bool = @code[temp_instruction_pointer] == ']'
            temp_closed_opened = opened_loops == closed_loops
            break if (temp_inst_is_bool & temp_closed_opened)
        end
        temp_instruction_pointer
    end

    def eval_loop()
        loop_register = @register_pointer
        loop_start_pointer = @instruction_pointer
        loop_end_pointer = seek_loop_end
        @instruction_pointer += 1
        loop do
            if(@instruction_pointer == loop_end_pointer)
                @instruction_pointer = loop_start_pointer + 1
            end
            case @code[@instruction_pointer]
            when '+'
                @registers[@register_pointer] += 1
            when '-'
                check_substraction
                @registers[@register_pointer] -= 1
            when '>'
                check_register_jump_right
                @register_pointer += 1
            when '<'
                check_register_jump_left
                @register_pointer -= 1
            when '['
                eval_loop
            when '.'
                print @registers[@register_pointer].chr
            when '!'
                @registers[@register_pointer] = 0
            when '?'
                print @registers[@register_pointer]
            when '$'
                puts 
                puts @registers
            when '#'
                @stored_val = @registers[@register_pointer]
            when '%'
                check_stored_jump_left
                @register_pointer -= @stored_val
            when '&'
                check_stored_jump_right
                @register_pointer += @stored_val
            when '/'
                puts @registers[@register_pointer]
            end

            @instruction_pointer += 1
            break if @registers[loop_register] == 0
        end
        return
    end

    def eval_instruction

        case @code[@instruction_pointer]
        when '+'
            @registers[@register_pointer] += 1
        when '-'
            check_substraction
            @registers[@register_pointer] -= 1
        when '>'
            check_register_jump_right
            @register_pointer += 1
        when '<'
            check_register_jump_left
            @register_pointer -= 1
        when '['
            eval_loop()
        when '.'
            print @registers[@register_pointer].chr
        when '!'
            @registers[@register_pointer] = 0
        when '?'
            print @registers[@register_pointer]
        when '$'
            puts 
            puts @registers
        when '#'
            @stored_val = @registers[@register_pointer]
        when '%'
            check_stored_jump_left
            @register_pointer -= @stored_val
        when '&'
            check_stored_jump_right
            @register_pointer += @stored_val
        when '/'
            puts @registers[@register_pointer]
        end
        @instruction_pointer += 1
    end

    def next_instruction
        eval_instruction
    end

    def run
        while @instruction_pointer < @code.bytesize
            next_instruction
        end
    end

end

# + -> Adds 1 to the register
# - -> Subtracts 1 from the register
# > -> Adds 1 to the register pointer
# < -> Subtracts 1 from the register pointer
# [.......] -> Loops as long as the current register is not 0 
# . -> Prints the current register as ascii
# ! -> Sets current register to 0
# ? -> Prints the current register as integer
# $ -> Print registers for debuffinf
# # -> Stores val in current register
# % -> Jumps `val` registers to the left
# & -> Jumps `val` registers to the right
# / -> Prints the current register as ascii with newline

file_name = ""
registers_count = 16
verbose = 0

OptionParser.parse do |parser|
    parser.banner = "Brainfuck interpreter programmed in Crystal"

    parser.on "-f NAME", "--file=NAME", "Run Brainfuck code from file" do |name|
        file_name = name
    end

    parser.on "-r SIZE", "--register_size=SIZE", "Set Register-Size (Normal is 16)" do |size|
        registers_count = size.to_i
    end

    parser.on "-v VERBOSE", "--verbose=VERBOSE", "Print Registers at the end of the program (Int 0 => false(default), 1 => true)" do |verbose_resp|
        verbose = verbose_resp.to_i
    end

    parser.on "-h", "--help", "Show help" do
        puts parser
        exit
    end



end

begin
    file_content = File.read(file_name).delete('\n')
    a = Brainfuck.new file_content, registers_count
    a.run
    if(verbose == 1)
        a.pretty_print
    end
rescue File::NotFoundError
    puts "File not found"
    exit
end
