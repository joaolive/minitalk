/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client_bonus.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: joaolive <joaolive@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/16 10:45:38 by joaolive          #+#    #+#             */
/*   Updated: 2025/09/19 15:11:05 by joaolive         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

volatile sig_atomic_t	g_flag = 0;

static void	ft_ack_message(int signum)
{
	if (signum == SIGUSR1)
		ft_printf("Message received successfully!\n");
	g_flag = 1;
}

static void	ft_encode_message(pid_t server_pid, char letter, int i)
{
	unsigned char	bit;

	while (i--)
	{
		g_flag = 0;
		bit = (letter >> i) & 1;
		if (bit == 1)
			kill(server_pid, SIGUSR2);
		else
			kill(server_pid, SIGUSR1);
		while (!g_flag)
			pause();
	}
}

static int	ft_validate_pid(char *str)
{
	if (!str)
		return (0);
	while (*str)
		if (!ft_isdigit(*str++))
			return (0);
	return (1);
}

int	main(int argc, char **argv)
{
	pid_t				pid;
	struct sigaction	action;
	size_t				i;
	size_t				len;

	if (argc != 3 || !ft_validate_pid(argv[1]))
	{
		ft_putendl_fd("Invalid PID", 2);
		exit(1);
	}
	pid = getpid();
	ft_bzero(&action, sizeof(struct sigaction));
	action.sa_handler = ft_ack_message;
	sigemptyset(&action.sa_mask);
	sigaction(SIGUSR1, &action, NULL);
	sigaction(SIGUSR2, &action, NULL);
	i = 0;
	len = ft_strlen(argv[2]);
	while (i <= len)
		ft_encode_message(ft_atoi(argv[1]), argv[2][i++], 8);
	exit(0);
}
