# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joaolive <joaolive@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/06 05:55:59 by joaolive          #+#    #+#              #
#    Updated: 2025/09/17 16:26:06 by joaolive         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Executables
CLIENT = client
SERVER = server

# Bonus
CLIENT_BONUS = bonus/client
SERVER_BONUS = bonus/server

# Colors
CC_PINK = \033[38;2;255;121;198m
CC_BLUE = \033[38;2;139;233;253m
CC_YELLOW = \033[38;2;241;250;140m
RESET = \033[0m

# Tools
CC = cc
AR = ar rcs
RM = rm -rf

# Directories
SRC_DIR = src
OBJ_DIR = obj
BONUS_DIR = bonus
LIBFT_DIR = lib/libft

# Flags and Includes
CCFLAGS = -Wall -Wextra -Werror -g
DEPFLAGS = -MMD -MP
CPPFLAGS = -Iinclude -I$(LIBFT_DIR)/include

# Libft
LDFLAGS = -L$(LIBFT_DIR)
LDLIBS = -lft

# Source files
CLIENT_SRC = $(addprefix $(SRC_DIR)/, $(addsuffix .c, client))
SERVER_SRC = $(addprefix $(SRC_DIR)/, $(addsuffix .c, server))
CLIENT_BONUS_SRC = $(addprefix $(SRC_DIR)/, $(addsuffix _bonus.c, client))
SERVER_BONUS_SRC = $(addprefix $(SRC_DIR)/, $(addsuffix _bonus.c, server))

# Object files
CLIENT_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(CLIENT_SRC))
SERVER_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SERVER_SRC))
CLIENT_BONUS_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(CLIENT_BONUS_SRC))
SERVER_BONUS_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SERVER_BONUS_SRC))

# Dependencies
DEPS = $(CLIENT_OBJS:.o=.d) $(SERVER_OBJS:.o=.d) $(CLIENT_BONUS_OBJS:.o=.d) $(SERVER_BONUS_OBJS:.o=.d)

all: $(CLIENT) $(SERVER)

bonus: $(CLIENT_BONUS) $(SERVER_BONUS)

# Mandatory
$(CLIENT): $(CLIENT_OBJS) $(LIBFT_DIR)/libft.a
	@$(CC) $(CLIENT_OBJS) -o $@ $(LDFLAGS) $(LDLIBS)
	@echo "🎉 $@ compiled successfully! 🎊"

$(SERVER): $(SERVER_OBJS) $(LIBFT_DIR)/libft.a
	@$(CC) $(SERVER_OBJS) -o $@ $(LDFLAGS) $(LDLIBS)
	@echo "🎉 $@ compiled successfully! 🎊"

$(CLIENT_BONUS): $(CLIENT_BONUS_OBJS) $(LIBFT_DIR)/libft.a
	@mkdir -p $(BONUS_DIR)
	@$(CC) $(CLIENT_BONUS_OBJS) -o $@ $(LDFLAGS) $(LDLIBS)
	@echo "✨ $@ compiled successfully! 🎊"

$(SERVER_BONUS): $(SERVER_BONUS_OBJS) $(LIBFT_DIR)/libft.a
	@mkdir -p $(BONUS_DIR)
	@$(CC) $(SERVER_BONUS_OBJS) -o $@ $(LDFLAGS) $(LDLIBS)
	@echo "✨ $@ compiled successfully! 🎊"

$(LIBFT_DIR)/libft.a:
	@$(MAKE) -s -C $(LIBFT_DIR)

# Include dependency files to track header changes
-include $(DEPS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	@printf "  $(CC_BLUE)[CC]$(RESET) $(CC_YELLOW)Compiling$(RESET) $(CC_PINK)MINITALK$(RESET) $(CC_YELLOW)module$(RESET) $(CC_BLUE)%-28s$(RESET) -> $(CC_PINK)%s$(RESET)\n" $< $@
	@$(CC) $(CCFLAGS) $(DEPFLAGS) $(CPPFLAGS) -c $< -o $@

# Cleaning Rules
clean:
	@$(RM) $(OBJ_DIR)
	@make clean -s -C $(LIBFT_DIR)
	@echo "🧼 Object files cleaned!"

fclean: clean
	@$(RM) $(CLIENT) $(SERVER) $(BONUS_DIR)
	@make fclean -s -C $(LIBFT_DIR)
	@echo "🧹 Full clean complete! Library removed."

re: fclean all
	@echo "🚀 Project has been rebuilt from scratch!"

# PHONY Targets
.PHONY: all clean fclean re bonus
