`ifndef ADDER_DRIVER_SV
`define ADDER_DRIVER_SV

class adder_driver extends uvm_driver #(adder_item);
    `uvm_component_utils(adder_driver)

    virtual adder_if vif;

    function new(string name = "adder_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Khong the lay virtual interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);

        forever begin
            seq_item_port.get_next_item(req);
            
            drive_item(req);
            
            seq_item_port.item_done();
        end
    endtask

virtual task drive_item(adder_item item);
        
        if (item.do_reset_mid == 1'b1) begin
            `uvm_info("DRV", "Thuc hien RESET giua chung theo lenh tu Sequence...", UVM_LOW)
            vif.rst_n <= 1'b0;
            vif.drv_cb.a_in  <= 8'h0;
            vif.drv_cb.b_in  <= 8'h0;
            repeat(3) @(vif.drv_cb);
            vif.rst_n <= 1'b1;
            
            return; 
        end

        @(vif.drv_cb);

        if (item.inject_glitch == 1'b1) begin
            `uvm_info("DRV", "Bom nhieu (Glitch) vao tin hieu...", UVM_LOW)
            vif.a_in <= 8'h00;
            #2ns; 
        end

        vif.drv_cb.a_in <= item.a_in;
        vif.drv_cb.b_in <= item.b_in;
        
        `uvm_info("DRV", $sformatf("Driving: A=%0d, B=%0d", item.a_in, item.b_in), UVM_HIGH)
        
    endtask
endclass

`endif
