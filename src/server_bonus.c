/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: joaolive <joaolive@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/15 10:19:08 by joaolive          #+#    #+#             */
/*   Updated: 2025/09/17 15:04:41 by joaolive         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

static void	ft_decode_handler(int signum, siginfo_t *info, void *context)
{
	static int				count;
	static unsigned char	letter;
	int						sig;

	(void)context;
	letter <<= 1;
	if (signum == SIGUSR2)
		letter |= 1;
	count++;
	sig = SIGUSR2;
	if (count == 8)
	{
		if (!letter)
			sig = SIGUSR1;
		else
			ft_putchar_fd(letter, 2);
		count = 0;
		letter = 0;
	}
	kill(info->si_pid, sig);
}

int	main(void)
{
	pid_t				pid;
	struct sigaction	action;

	pid = getpid();
	ft_bzero(&action, sizeof(struct sigaction));
	action.sa_sigaction = ft_decode_handler;
	action.sa_flags = SA_SIGINFO;
	sigemptyset(&action.sa_mask);
	sigaction(SIGUSR1, &action, NULL);
	sigaction(SIGUSR2, &action, NULL);
	ft_printf("Server PID -> %d\n", pid);
	while (1)
		pause();
	exit(0);
}
