class base_sequence extends uvm_sequence #(adder_item);
    `uvm_object_utils(base_sequence)

    int loop_count = 1000;

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("SEQ", "Bat dau thuc thi Master Test Plan", UVM_LOW)

        // Kịch bản 1: Max Min
        `uvm_info("SEQ", "Kich ban 1: Gia tri max min <<<", UVM_LOW)
        send_directed_item(8'hFF, 8'hFF);
        send_directed_item(8'hFF, 8'h00);
        send_directed_item(8'h00, 8'h00);
        send_directed_item(8'h00, 8'hFF);

        // Kịch bản 2: Đảo bit (55/AA)
        `uvm_info("SEQ", "Kich ban 2: Dao bit (55/AA) <<<", UVM_LOW)
        send_directed_item(8'h55, 8'hAA);
        send_directed_item(8'hAA, 8'h55);

        // Kịch bản 3: Nhiễu
        `uvm_info("SEQ", "Kich ban 3: Nhieu (Glitch) <<<", UVM_LOW)
        req = adder_item::type_id::create("req");
        start_item(req);
        req.a_in = 8'h00;
        req.inject_glitch = 1; // Nhờ Driver tạo delay #2ns
        finish_item(req);

        // Kịch bản 4: Reset Mid-stream
        `uvm_info("SEQ", "Kich ban 4: RESET MID-STREAM <<<", UVM_LOW)
        req = adder_item::type_id::create("req");
        start_item(req);
        if(!req.randomize()) `uvm_error("SEQ", "Randomize failed")
        req.do_reset_mid = 1;
        finish_item(req);

        // Kịch bản 5: X/Z
        `uvm_info("SEQ", "Kich ban 5: X/Z <<<", UVM_LOW)
        send_directed_item(8'bxxxx_xxxx, 8'bzzzz_zzzz);

        // Kịch bản 6: Random Test
        `uvm_info("SEQ", $sformatf("Kich ban 6: RANDOM (%0d packets) <<<", loop_count), UVM_LOW)
        repeat(loop_count) begin
            req = adder_item::type_id::create("req");
            start_item(req);
            if(!req.randomize()) `uvm_error("SEQ", "Random failed")
            finish_item(req);
        end

        `uvm_info("SEQ", "Hoan thanh toan bo kich ban!", UVM_LOW)
    endtask

    virtual task send_directed_item(logic [7:0] a, logic [7:0] b);
        req = adder_item::type_id::create("req");
        start_item(req);
        req.a_in = a;
        req.b_in = b;
        finish_item(req);
    endtask
endclass