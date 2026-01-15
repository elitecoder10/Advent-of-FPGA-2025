module factorization (
    input  logic [4:0]  digit_count,
    output logic [2:0]  factors [0:2]
);

always_comb begin
    case (digit_count)
    2 : factors = '{1, 0, 0};
    3 : factors = '{1, 0, 0};
    4 : factors = '{1, 2, 0};
    5 : factors = '{1, 0, 0};
    6 : factors = '{1, 2, 3};
    7 : factors = '{1, 0, 0};
    8 : factors = '{1, 2, 4};
    9 : factors = '{1, 3, 0};
    10: factors = '{1, 2, 5};
    default : factors = '{0, 0, 0};
    endcase
end
endmodule
