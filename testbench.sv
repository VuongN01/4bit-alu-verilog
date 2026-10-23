module tb;
  reg  [3:0] a, b;
  reg  [2:0] op;
  wire [3:0] result;
  wire       carry_out, zero;
  integer    errors = 0;

  alu4 uut (.a(a), .b(b), .op(op), .result(result), .carry_out(carry_out), .zero(zero));
  task check(input [2:0] o, input [3:0] x, input [3:0] y,
             input [3:0] exp_r, input exp_c, input exp_z);
    begin
      op = o; a = x; b = y; #10;
      if (result === exp_r && carry_out === exp_c && zero === exp_z)
        $display("PASS  op=%b a=%b b=%b | result=%b carry=%b zero=%b",
                 op, a, b, result, carry_out, zero);
      else begin
        $display("FAIL  op=%b a=%b b=%b | got result=%b carry=%b zero=%b, expected %b %b %b",
                 op, a, b, result, carry_out, zero, exp_r, exp_c, exp_z);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    check(3'b000, 4'd5,    4'd3,    4'b1000, 0,    0);  
    check(3'b000, 4'd7,    4'd9,    4'b0000, 1,    1);  
    check(3'b001, 4'd6,    4'd2,    4'b0100, 1,    0);  
    check(3'b001, 4'd3,    4'd5,    4'b1110, 0,    0);  
    check(3'b010, 4'b1100, 4'b1010, 4'b1000, 0,    0);  
    check(3'b011, 4'b1100, 4'b1010, 4'b1110, 0,    0);  
    check(3'b100, 4'b1100, 4'b1010, 4'b0110, 0,    0);  
    check(3'b101, 4'b1100, 4'b0000, 4'b0011, 0,    0);  

    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $finish;
  end
endmodule
