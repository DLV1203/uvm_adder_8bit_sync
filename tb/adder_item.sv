`ifndef ADDER_ITEM_SV
`define ADDER_ITEM_SV

class adder_item extends uvm_sequence_item;
    rand logic [7:0] a_in;
    rand logic [7:0] b_in;
         logic [8:0] sum_out;

	
	bit do_reset_mid;
    bit inject_glitch;
	
    `uvm_object_utils_begin(adder_item)
        `uvm_field_int(a_in,    UVM_ALL_ON)
        `uvm_field_int(b_in,    UVM_ALL_ON)
        `uvm_field_int(sum_out, UVM_ALL_ON)
		`uvm_field_int(do_reset_mid, UVM_ALL_ON)
        `uvm_field_int(inject_glitch, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "adder_item");
        super.new(name);
    endfunction

	constraint c_corner {
        a_in dist {8'hFF :/ 10, [8'h01:8'hFE] :/ 80, 8'h00 :/ 10};
        b_in dist {8'hFF :/ 10, [8'h01:8'hFE] :/ 80, 8'h00 :/ 10};
    }

endclass

`endif
