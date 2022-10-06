
//Decoder Module
//This module decodes a 5 bit binary number to a 7 bit binary number

module decoder(decoder_in,decoder_out);
    input [4:0] decoder_in;
    output [6:0] decoder_out;
    reg [6:0] decoder_out;
    always @ (decoder_in)
        case(decoder_in)
        5'b00001:    begin     decoder_out=7'b1111001 ;    end //1
        5'b00010:    begin     decoder_out=7'b0100100 ;    end //2
        5'b00011:    begin     decoder_out=7'b0110000 ;    end //3
        5'b00100:    begin     decoder_out=7'b0011001 ;    end //4
        5'b00101:    begin     decoder_out=7'b0010010 ;    end //5
        5'b00110:    begin     decoder_out=7'b0000010 ;    end //6
        5'b00111:    begin     decoder_out=7'b1111000 ;    end //7
        5'b01000:    begin     decoder_out=7'b00000000;    end //8
        5'b01001:    begin     decoder_out=7'b0010000 ;    end //9
        5'b01010:    begin     decoder_out=7'b0001000 ;    end //A
        5'b01011:    begin     decoder_out=7'b0000011 ;    end //B
        5'b01100:    begin     decoder_out=7'b1000110 ;    end //C
        5'b01101:    begin     decoder_out=7'b0100001 ;    end //D
        5'b01110:    begin     decoder_out=7'b0000110 ;    end //E
        5'b01111:    begin     decoder_out=7'b0001110 ;    end //F
		//NEW VALUES----------------------------------------------
        5'b10000:    begin     decoder_out=7'b1000010 ;    end //G
        5'b10001:    begin     decoder_out=7'b0001001 ;    end //H
	5'b10010:    begin     decoder_out=7'b1001111 ;    end //I
	5'b10011:    begin     decoder_out=7'b1000111 ;    end //L
	5'b10100:    begin     decoder_out=7'b1101010 ;    end //M
	5'b10101:    begin     decoder_out=7'b0001100 ;    end //P
	5'b10110:    begin     decoder_out=7'b0010010 ;    end //S
	5'b10111:    begin     decoder_out=7'b0000111 ;    end //T
	5'b11000:    begin     decoder_out=7'b1000001 ;    end //V
	5'b11001:    begin     decoder_out=7'b0111111 ;    end //-	
        default:     begin     decoder_out=7'b1000000 ;    end //0

        endcase
endmodule      


