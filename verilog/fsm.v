
module fsm(input clk,
          input s_clk,
          input CS,
          input read_write,
          output reg miso_buff, // MISO enable
          output reg dm_we, // data memory write enable
          output reg ad_we, // address write enable
          output reg sr_we // shift register write enable
);

parameter state_get = 0;
parameter state_got = 1;
parameter state_read = 2;
parameter state_read2 = 3;
parameter state_read3 = 4;
parameter state_write = 5;
parameter state_write2 = 6;
parameter state_done = 7;

reg[3:0] count = 0;
reg[2:0] curr_state = state_get;
reg count_state = 0;

always @(posedge clk) begin

  // reset all flags at beginning of clock cycle
  ad_we = 0;
  miso_buff = 0;
  sr_we = 0;
  dm_we = 0;

  // if chip select is high, return to get state
  if (CS == 1) begin
    curr_state <= state_get;
    count <= 0;
    count_state <= 1;
  end

  // this be the real fsm
  else begin
    case (curr_state)
        state_get: begin
          count_state <= 1;
          if (count == 8) begin
            curr_state <= state_got;
            count <= 0;
            count_state <= 0;
          end
        end

        state_got: begin
          ad_we <= 1;
          if (read_write == 1)
            curr_state <= state_read;
          else begin
            curr_state <= state_write;
            count_state <= 1;
          end
        end

        state_read: begin
          curr_state <= state_read2;
        end

        state_read2: begin
          sr_we <= 1;
          curr_state <= state_read3;
          count_state <= 1;
        end

        state_read3: begin
          miso_buff <= 1;
          if (count == 8) begin
            curr_state <= state_done;
            count <= 0;
            count_state <= 0;
          end
        end

        state_write: begin
          count_state <= 1;
          if (count == 8) begin
            curr_state <= state_write2;
            count <= 0;
            count_state <= 0;
          end
        end

        state_write2: begin
          dm_we <= 1;
          curr_state <= state_done;
        end

        state_done: begin
        end
    endcase
  end
end

// If the fsm is in a counting state, increment the count
always @(posedge s_clk) begin
  if (count_state == 1)
    count <= count + 1;
end

endmodule
