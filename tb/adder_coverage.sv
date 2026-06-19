class adder_coverage extends uvm_subscriber #(adder_item);
    `uvm_component_utils(adder_coverage)

    adder_item item;

    covergroup adder_cg;
        option.per_instance = 1;
        
        cp_a: coverpoint item.a_in {
            bins low    = {[0:63]};
            bins mid    = {[64:191]};
            bins high   = {[192:255]};
            bins corner = {0, 255};
        }
        cp_b: coverpoint item.b_in {
            bins range[] = {[0:255]};
        }
        cross_ab: cross cp_a, cp_b;
    endgroup

    function new(string name = "adder_coverage", uvm_component parent = null);
        super.new(name, parent);
        adder_cg = new();
    endfunction

    virtual function void write(adder_item t);
        this.item = t;
        adder_cg.sample();
    endfunction
endclass
