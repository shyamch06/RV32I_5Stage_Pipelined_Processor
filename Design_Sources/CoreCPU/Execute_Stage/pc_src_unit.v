module pc_src_unit (

    input BranchTakenE,
    input JumpE,

    output PCSrcE

);

    assign PCSrcE = BranchTakenE | JumpE;

endmodule