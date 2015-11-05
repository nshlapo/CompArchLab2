

module fsm
(
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

  // NOTE: This overflows at 7.
  reg[2:0] count = 0;
  reg[2:0] curr_state = state_get;

  always @(s_clk) begin

    if (CS == 1) begin
      curr_state = state_get;
      count = 0;
    end

    /*ad_we = 0;
    miso_buff = 0;
    sr_we = 0;
    dm_we = 0;*/

    case (curr_state)
      state_get: begin

        // I THINK THIS IS RIGHT. WHEN COUNT=7, WE RESET COUNT AND PROGRESS THE STAGE.
        if (count == 7) begin
          curr_state <= state_got;
        end
        count <= count + 1;
        $display(count);
      end

      /*state_got: begin
        ad_we <= 1;
        if (read_write == 1)
          curr_state <= state_read;
        else
          curr_state <= state_write;
      end

      state_read: begin
        curr_state <= state_read2;
      end

      state_read2: begin
        sr_we <= 1;
        curr_state <= state_read3;
      end

      state_read3: begin
        miso_buff <= 1;
        if (count == 8) begin
          curr_state <= state_done;
          count <= 0;
        end
        else
          count <= count + 1;
      end

      state_write: begin
        if (count == 8) begin
          curr_state <= state_write2;
          count <= 0;
        end
        else
          count <= count + 1;
      end

      state_write2: begin
        dm_we <= 1;
        curr_state <= state_done;
      end

      state_done: begin

      end*/
    endcase
  end

endmodule
