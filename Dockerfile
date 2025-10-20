# --- Estágio 1: Build ---
# Usamos uma imagem base que já tem o Godot e os templates de exportação.
# Troque '4.2.2' pela versão exata do seu projeto Godot.
# Imagens disponíveis: https://ghcr.io/godot-ci/godot-ci
# Use a imagem oficial e a tag 'stable' correta
FROM barichello/godot-ci:4.5.1 AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia todos os arquivos do seu projeto (da sua máquina) 
# para o diretório de trabalho (dentro do contêiner)
COPY . .

# Cria os diretórios de saída para onde os builds irão
RUN mkdir -p /app/build/windows
RUN mkdir -p /app/build/linux

# --- O COMANDO MÁGICO ---
# Executa a exportação do Godot.
# O Docker vai rodar este comando DENTRO do contêiner.

# Exemplo: Exportando para Windows
# "Windows Desktop" deve ser o NOME EXATO do seu preset no Godot
RUN godot --headless --export-release "Windows Desktop" /app/build/windows/watchouthost.exe

# Exemplo: Exportando para Linux
# "Linux/X11" deve ser o NOME EXATO do seu preset no Godot
RUN godot --headless --export-release "Linux" /app/build/linux/watchouthost.x86_64

# --- Estágio 2: Resultado (Opcional, mas boa prática) ---
# Esta é uma imagem "limpa" que conterá APENAS os arquivos do jogo.
# Isso torna a imagem final muito menor.
FROM scratch

# Define o diretório de trabalho
WORKDIR /game

# Copia APENAS os arquivos construídos (do estágio 'builder') 
# para esta nova imagem limpa.
COPY --from=builder /app/build/ .