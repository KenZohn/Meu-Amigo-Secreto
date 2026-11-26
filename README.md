# Meu Amigo Secreto - Sorteador

Meu Amigo Secreto é um sorteador de amigo secreto desenvolvido no Godot.

Link do aplicativo: https://kenzohn.github.io/Meu-Amigo-Secreto/

### Funcionalidades
- Adição dos participantes. Tem um limite de 15 caracteres, para limitar o tamanho do código gerado.
- Seleção dos restritos (quem não pode tirar quem).
- Os participantes serão sorteados de forma que gere um único ciclo caso possível. Dependendo das restrições, pode não ser possível gerar um único ciclo, então serão gerados mais.
- O código gerado é uma criptografia do nome do participante + chave + número de caracteres do nome. A chave é o horário em que o código foi gerado.
- A revelação do nome é realizada com a descriptografia do código.

### Game Engine
- Godot (GDScript)

### Assets
- Cup Nooble (https://cupnooble.itch.io/)

## Como Utilizar

### Sortear
- Adicione os participantes
- Selecione quem não pode tirar quem
- Copie e envie os códigos para cada um dos participantes

### Revelar
- Insira o código e revele
