class adder_test extends uvm_test;
    `uvm_component_utils(adder_test)

    adder_env env;

    function new(string name = "adder_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        base_sequence seq;
        phase.raise_objection(this);
        seq = base_sequence::type_id::create("seq");
        seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass
