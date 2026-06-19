class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    virtual adder_if vif;
    uvm_analysis_port #(adder_item) item_collected_port;

    function new(string name = "adder_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Khong the lay virtual interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_item item;
        forever begin
            item = adder_item::type_id::create("item");
            
            @(vif.mon_cb);
            item.a_in    = vif.mon_cb.a_in;
            item.b_in    = vif.mon_cb.b_in;
            
            item.sum_out = vif.mon_cb.sum_out;

            item_collected_port.write(item);
        end
    endtask
endclass
