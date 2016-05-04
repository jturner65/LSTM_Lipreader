function lstm_writer_configure()
    global config;
    config.input_size = 1600;
    config.slice_points = [];
    config.hidden_layer_size = [256 256];
    config.output_size = 33;
    config.max_time_steps = 25;
    config.input_valid_len = 25;
    config.output_valid_len = 25;
    config.batch_size = 50;
    
    config.weight_range = 0.08;     % -weight_range to weight_range
    config.b_offset_input_gate = -0.3;
    config.b_offset_output_gate = -0.3;
    config.b_offset_forget_gate = 0.6;
    config.fudge_factor = 1e-6;
    config.learning_rate = 0.1;
    config.temperature = 1;
    config.decay = 0; %5e-7 / 10;    
    config.weight_decay = [0.08];
end

