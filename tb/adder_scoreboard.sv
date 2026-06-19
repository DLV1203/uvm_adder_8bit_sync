class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)

    uvm_analysis_export #(adder_item) item_collected_export;
    uvm_tlm_analysis_fifo #(adder_item) item_fifo;

    int expected_queue[$];

    function new(string name = "adder_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
        item_fifo = new("item_fifo", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_collected_export.connect(item_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_item item;
        int expected_sum;
        
        forever begin
            item_fifo.get(item);
            
            expected_sum = item.a_in + item.b_in;
            expected_queue.push_back(expected_sum);
            
            if (expected_queue.size() > 2) begin
                int val_to_compare = expected_queue.pop_front();
                if (item.sum_out == val_to_compare) begin
					//`uvm_info("SCB", $sformatf("MATCH! Sum_out=%0d (Khop voi du kien 2 nhip truoc)", item.sum_out), UVM_LOW)                
					end else begin
                    `uvm_error("SCB", $sformatf("MISMATCH! Real=%0d, Exp=%0d", item.sum_out, val_to_compare))
                end
            end
        end
    endtask
endclass
