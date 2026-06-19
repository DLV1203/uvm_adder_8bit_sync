class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)

    adder_agent    agt;
    adder_scoreboard scb;
    adder_coverage cov;

    function new(string name = "adder_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = adder_agent::type_id::create("agt", this);
        scb = adder_scoreboard::type_id::create("scb", this);
        cov = adder_coverage::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.item_collected_port.connect(scb.item_collected_export);
        
        agt.mon.item_collected_port.connect(cov.analysis_export); 
    endfunction
endclass