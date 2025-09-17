/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: joaolive <joaolive@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/15 10:19:08 by joaolive          #+#    #+#             */
/*   Updated: 2025/09/17 11:25:31 by joaolive         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

static void	ft_decode_handler(int signum, siginfo_t *info, void *context)
{
	static int				count;
	static unsigned char	letter;

	(void)context;
	letter <<= 1;
	if (signum == SIGUSR2)
		letter |= 1;
	count++;
	if (count == 8)
	{
		if (!letter)
			kill(info->si_pid, SIGUSR1);
		else
		{
			kill(info->si_pid, SIGUSR2);
			ft_printf("%c", letter);
		}
		count = 0;
		letter = 0;
		return ;
	}
	kill(info->si_pid, SIGUSR2);
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
