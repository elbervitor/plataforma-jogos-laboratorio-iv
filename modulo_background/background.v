module background_image_display (
  input wire clk,
  input wire reset,
  input wire [7:0] pixel_in [639:0][479:0],
  output wire [7:0] pixel_out [639:0][479:0],
  input wire [9:0] x_position,
  input wire [9:0] y_position,
  input wire [2:0] layout
);

  // Declaração de variáveis internas
  reg [7:0] pixel_buffer [639:0][479:0];
  reg [9:0] x_offset, y_offset;

  // Inicialização
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (integer i = 0; i < 639; i = i + 1) begin
        for (integer j = 0; j < 479; j = j + 1) begin
          pixel_buffer[i][j] = 0;
        end
      end
    end else begin
      // Carrega a imagem do buffer de entrada para o buffer de saída
      for (integer i = 0; i < 639; i = i + 1) begin
        for (integer j = 0; j < 479; j = j + 1) begin
          pixel_buffer[i][j] = pixel_in[i][j];
        end
      end
    end
  end

  // Calcula o deslocamento horizontal e vertical da imagem
  always @(posedge clk) begin
    x_offset = x_position % 640;
    y_offset = y_position % 480;
  end

  // Exibe a imagem na tela
  always @(posedge clk) begin
    for (integer i = 0; i < 639; i = i + 1) begin
      for (integer j = 0; j < 479; j = j + 1) begin
        // Determina a posição da imagem no buffer de saída
        integer image_x = i + x_offset;
        integer image_y = j + y_offset;

        // Aplica o layout da imagem
        if (layout == 0) begin
          // Horizontal
          pixel_out[i][j] = pixel_buffer[image_x][j];
        end else if (layout == 1) begin
          // Vertical
          pixel_out[i][j] = pixel_buffer[i][image_y];
        end else begin
          // Igualitária
          if (i < 320 && j < 240) begin
            // Primeiro quadrante
            pixel_out[i][j] = pixel_buffer[image_x][image_y];
          end else if (i < 320 && j >= 240) begin
            // Segundo quadrante
            pixel_out[i][j] = pixel_buffer[image_x][239 - image_y];
          end else if (i >= 320 && j < 240) begin
            // Terceiro quadrante
            pixel_out[i][j] = pixel_buffer[239 - image_x][image_y];
          end else begin
            // Quarto quadrante
            pixel_out[i][j] = pixel_buffer[239 - image_x][239 - image_y];
          end
        end
      end
    end
  
endmodule