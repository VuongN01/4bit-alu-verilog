
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
  
endmodule

module adder4(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire c1, c2, c3;   

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout));
    
endmodule

module alu4(
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] op,
    output reg [3:0] result,
    output reg       carry_out,
    output           zero
);
    wire [3:0] add_sum;
    wire       add_c;
    wire [3:0] sub_diff;
    wire       sub_c;

    adder4 add_unit (.a(a), .b(b),  .cin(1'b0), .sum(add_sum),  .cout(add_c));
    adder4 sub_unit (.a(a), .b(~b), .cin(1'b1), .sum(sub_diff), .cout(sub_c));  

    always @(*) begin
        carry_out = 1'b0;
        case (op)
            3'b000: begin result = add_sum;  carry_out = add_c; end  
            3'b001: begin result = sub_diff; carry_out = sub_c; end  
            3'b010: result = a & b;                                  
            3'b011: result = a | b;                                  
            3'b100: result = a ^ b;                                  
            3'b101: result = ~a;                                     
            default: result = 4'b0000;
        endcase
    end

    assign zero = (result == 4'b0000);
endmodule
