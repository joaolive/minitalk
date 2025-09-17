# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joaolive <joaolive@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/06 05:55:59 by joaolive          #+#    #+#              #
#    Updated: 2025/09/17 11:42:27 by joaolive         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CLIENT = client
SERVER = server

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
LIBFT_DIR = lib/libft

# Flags and Includes
CCFLAGS = -Wall -Wextra -Werror -g
DEPFLAGS = -MMD -MP
CPPFLAGS = -Iinclude -I$(LIBFT_DIR)/include

# Libft
LDFLAGS = -L$(LIBFT_DIR)
LDLIBS = -lft

CLIENT_NAMES = $(addsuffix .c, client)
SERVER_NAMES = $(addsuffix .c, server)

# Source files
CLIENT_SRC = $(addprefix $(SRC_DIR)/, $(CLIENT_NAMES))
SERVER_SRC = $(addprefix $(SRC_DIR)/, $(SERVER_NAMES))

# Object files
CLIENT_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(CLIENT_SRC))
SERVER_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SERVER_SRC))

# Dependencies
DEPS = $(CLIENT_OBJS:.o=.d) $(SERVER_OBJS:.o=.d)

all: $(CLIENT) $(SERVER)

$(CLIENT): $(CLIENT_OBJS) $(LIBFT_DIR)/libft.a
	@$(CC) $(CLIENT_OBJS) -o $(CLIENT) $(LDFLAGS) $(LDLIBS)
	@echo "🎉 $(CLIENT) compiled successfully! 🎊"

$(SERVER): $(SERVER_OBJS) $(LIBFT_DIR)/libft.a
	@$(CC) $(SERVER_OBJS) -o $(SERVER) $(LDFLAGS) $(LDLIBS)
	@echo "🎉 $(SERVER) compiled successfully! 🎊"

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
	@$(RM) $(CLIENT) $(SERVER)
	@make fclean -s -C $(LIBFT_DIR)
	@echo "🧹 Full clean complete! Library removed."

re: fclean all
	@echo "🚀 Project has been rebuilt from scratch!"

# PHONY Targets
.PHONY: all clean fclean re
