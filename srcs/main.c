#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

size_t	ft_strlen(const char *s);
char	*ft_strcpy(char *dest, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char 	*ft_strdup(const char *s);

typedef struct s_list
{
	void *data;
	struct s_list *next;
} t_list;

int		ft_atoi_base(char *str, char *base);
void	ft_list_push_front(t_list **begin_list, void *data);
int		ft_list_size(t_list *begin_list);
void	ft_list_sort(t_list **begin_list, int (*cmp)());
void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

void	mock_free();
void	test_ft_strlen(const char *s);
void	test_ft_strcpy(char *dest, size_t dest_size, const char *src);
void	test_ft_strcmp(const char *s1, const char *s2);
void	ft_lstclear(t_list **lst, void (*del)(void *));

enum tests
{
	FT_STRLEN = 1 << 0,
	FT_STRCPY = 1 << 1,
	FT_STRCMP = 1 << 2,
	FT_WRITE = 1 << 3,
	FT_READ = 1 << 4,
	FT_STRDUP = 1 << 5,
	FT_ATOI_BASE = 1 << 6,
	FT_LIST_PUSH_FRONT = 1 << 7,
	FT_LIST_SIZE = 1 << 8,
	FT_LIST_SORT = 1 << 9,
	FT_LIST_REMOVE_IF = 1 << 10
};

unsigned int tests = FT_STRLEN | FT_STRCPY | FT_STRCMP | FT_WRITE | FT_READ | FT_STRDUP | FT_ATOI_BASE | FT_LIST_PUSH_FRONT | FT_LIST_SIZE | FT_LIST_SORT | FT_LIST_REMOVE_IF;

int	main(void)
{
	if (tests & FT_STRLEN)
	{
		puts(" --- Testing ft_strlen ---\n");

		test_ft_strlen("Test basique");
		test_ft_strlen("Test");
		test_ft_strlen("");
		char coucou[10] = "salut";
		test_ft_strlen(coucou);
		test_ft_strlen("a");
		test_ft_strlen("ab");
		test_ft_strlen("aa");
		test_ft_strlen("abc");
		test_ft_strlen("abb");
		test_ft_strlen("aab");
		test_ft_strlen("aaa");
	}
	
	if (tests & FT_STRCPY)
	{
		puts(" --- Testing ft_strcpy ---\n");
		{
			char	dest[10];

			test_ft_strcpy(dest, 10, "salut");
		}
		{
			char	dest[10];

			bzero(dest, 10);
			test_ft_strcpy(dest, 10, "salut");
		}
		{
			char	dest[10];

			memset(dest, -1, 10);
			test_ft_strcpy(dest, 10, "salut");
		}
		{
			char	dest[10];

			memset(dest, -1, 10);
			test_ft_strcpy(dest, 10, "");
		}
		{
			char	dest[10];

			memset(dest, 0, 10);
			test_ft_strcpy(dest, 10, "");
		}
		{
			char	dest[10];

			memset(dest, 0, 10);
			test_ft_strcpy(dest, 10, "a");
		}
		{
			char	dest[10];

			memset(dest, -1, 10);
			test_ft_strcpy(dest, 10, "a");
		}
		{
			char	dest[10] = "salut";

			test_ft_strcpy(dest, 10, "a");
		}
		{
			char	dest[10] = "salut";

			test_ft_strcpy(dest, 10, "largersa");
		}
	}

	if (tests & FT_STRCMP)
	{
		puts(" --- Testing ft_strcmp ---\n");

		test_ft_strcmp("coucou", "coucou");
		test_ft_strcmp("coucou", "co");
		test_ft_strcmp("c", "co");
		test_ft_strcmp("", "co");
		test_ft_strcmp("erwe", "");
		test_ft_strcmp("", "");
		test_ft_strcmp("aaaaaaaaaaa", "aaaaaaaaaa");
		test_ft_strcmp("aaaaaaaaaa", "aaaaaaaaaaa");
		test_ft_strcmp("abcdefg", "abcdffg");
	}

	if (tests & FT_WRITE)
	{
		puts(" --- Testing ft_write ---\n");
		int	return_value;

		printf("Expecting `Salut`: ");
		fflush(stdout);
		printf(" 5 - %zd\n", ft_write(1, "Salut", 5));

		printf("Expecting ``: ");
		fflush(stdout);
		printf(" 0 - %zd\n", ft_write(1, "", 0));

		printf("Expecting `S`: ");
		fflush(stdout);
		printf(" 1 - %zd\n", ft_write(1, "S", 1));

		printf("Expecting `Salut`: ");
		fflush(stdout);
		printf(" 6 - %zd\n", ft_write(1, "Salut\n", 6));

		printf("Expecting `Error fd`: ");
		fflush(stdout);
		return_value = ft_write(5, "Invalid\n", 6);
		perror("");
		printf("-1 %d\n", return_value);
	}

	if (tests & FT_READ)
	{
		puts(" --- Testing ft_read ---\n");

		int fds[2];
		pipe(fds);

		int return_value;

		char buf[20];

		bzero(buf, 20);
		write(fds[1], "coucou", 6);
		return_value = ft_read(fds[0], buf, 20);
		printf("%s 6 - %d\n", buf, return_value);

		bzero(buf, 20);
		write(fds[1], "salut", 5);
		return_value = ft_read(fds[0], buf, 20);
		printf("%s 5 - %d\n", buf, return_value);

		bzero(buf, 20);
		write(fds[1], "s", 1);
		return_value = read(fds[0], buf, 20);
		printf("%s 1 - %d\n", buf, return_value);

		return_value = read(33, buf, 20);
		printf("-1 - %d Should print bad file descriptor: ", return_value);
		fflush(stdout);
		perror("");
	}

	if (tests & FT_STRDUP)
	{
		puts(" --- Testing ft_strdup ---\n");

		char	*str;
		str = ft_strdup("pouet");
		printf("Should print `pouet`: %s\n", str);
		free(str);
		str = ft_strdup("");
		printf("Should print ``: %s\n", str);
		free(str);
		str = ft_strdup("a");
		printf("Should print `a`: %s\n", str);
		free(str);
		str = ft_strdup("ab");
		printf("Should print `ab`: %s\n", str);
		free(str);
		str = ft_strdup("ceci est un tres long texte");
		printf("Should print `ceci est un tres long texte`: %s\n", str);
		free(str);
	}

	if (tests & FT_ATOI_BASE)
	{
		puts(" --- Testing ft_atoi_base ---\n");

		printf("Should print 42 %d\n", ft_atoi_base("42", "0123456789"));
		printf("Should print 42 %d\n", ft_atoi_base("101010", "01"));
		printf("Should print -42 %d\n", ft_atoi_base("-42", "0123456789"));
		printf("Should print -42 %d\n", ft_atoi_base("-101010", "01"));
		printf("Should print -42 %d\n", ft_atoi_base("--+---42", "0123456789"));
		printf("Should print -42 %d\n", ft_atoi_base("----+-101010", "01"));
		printf("Should print 42 %d\n", ft_atoi_base("--+--42", "0123456789"));
		printf("Should print 42 %d\n", ft_atoi_base("---+-101010", "01"));

		printf("Should print 42 %d\n", ft_atoi_base("     \t\v\n\r\f    42", "0123456789"));
		printf("Should print 42 %d\n", ft_atoi_base("     \t\v\n\r\f    101010", "01"));
		printf("Should print -42 %d\n", ft_atoi_base("     \t\v\n\r\f    -42", "0123456789"));
		printf("Should print -42 %d\n", ft_atoi_base("     \t\v\n\r\f    -101010", "01"));
		printf("Should print -42 %d\n", ft_atoi_base("     \t\v\n\r\f    --+---42", "0123456789"));
		printf("Should print -42 %d\n", ft_atoi_base("     \t\v\n\r\f    ----+-101010", "01"));
		printf("Should print 42 %d\n", ft_atoi_base("     \t\v\n\r\f    --+--42", "0123456789"));
		printf("Should print 42 %d\n", ft_atoi_base("     \t\v\n\r\f    ---+-101010", "01"));

		printf("Should print -2147483648 %d\n", ft_atoi_base("-2147483648", "0123456789"));
		printf("Should print 2147483647 %d\n", ft_atoi_base("2147483647", "0123456789"));
	}

	if (tests & FT_LIST_PUSH_FRONT)
	{
		puts(" --- Testing ft_list_push_front ---\n");

		t_list	*head = NULL;
		t_list	*cur;

		ft_list_push_front(&head, "Youpi");
		ft_list_push_front(&head, "Genial");
		ft_list_push_front(&head, "");
		ft_list_push_front(&head, "TOP");
		ft_list_push_front(&head, "SUPERBE");
		cur = head;
		while (cur)
		{
			printf("%s\n", (char *) cur->data);
			cur = cur->next;
		}
		ft_lstclear(&head, NULL);
	}

	if (tests & FT_LIST_SIZE)
	{
		puts(" --- Testing ft_list_size ---\n");

		t_list	*head = NULL;
		t_list	*cur;

		printf("%d\n", ft_list_size(head));
		ft_list_push_front(&head, "Youpi");
		printf("%d\n", ft_list_size(head));
		ft_list_push_front(&head, "Genial");
		printf("%d\n", ft_list_size(head));
		ft_list_push_front(&head, "");
		printf("%d\n", ft_list_size(head));
		ft_list_push_front(&head, "TOP");
		printf("%d\n", ft_list_size(head));
		ft_list_push_front(&head, "SUPERBE");
		printf("%d\n", ft_list_size(head));
		ft_lstclear(&head, NULL);
	}

	if (tests & FT_LIST_SORT)
	{
		puts(" --- Testing ft_list_sort ---\n");
		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Youpi");
			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "");
			ft_list_push_front(&head, "TOP");
			ft_list_push_front(&head, "SUPERBE");

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Youpi");
			ft_list_push_front(&head, "Genial");

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "Youpi");

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Genial");

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "Youpi");
			ft_list_push_front(&head, "Superbe");

			ft_list_sort(&head, &ft_strcmp);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}
	}

	if (tests & FT_LIST_REMOVE_IF)
	{
		puts(" --- Testing ft_list_remove_if ---\n");
		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Youpi1");
			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "");
			ft_list_push_front(&head, "TOP");
			ft_list_push_front(&head, "SUPERBE");
			ft_list_push_front(&head, "GENIAL");
			ft_list_push_front(&head, "Youpi2");
			ft_list_remove_if(&head, "Genial", &ft_strcmp, &mock_free);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_remove_if(&head, "Genial", &ft_strcmp, &mock_free);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Youpi");
			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "");
			ft_list_push_front(&head, "TOP");
			ft_list_push_front(&head, "SUPERBE");
			ft_list_push_front(&head, "GENIAL");
			ft_list_push_front(&head, "Youpi");
			ft_list_remove_if(&head, "Ge", &ft_strcmp, &mock_free);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}

		puts("-- Next test -- ");

		{
			t_list	*head = NULL;
			t_list	*cur;

			ft_list_push_front(&head, "Youpi");
			ft_list_push_front(&head, "Genial");
			ft_list_push_front(&head, "");
			ft_list_push_front(&head, "TOP");
			ft_list_push_front(&head, "SUPERBE");
			ft_list_push_front(&head, "GENIAL");
			ft_list_push_front(&head, "Youpi");
			ft_list_remove_if(&head, "Ge", &ft_strcmp, NULL);
			cur = head;
			while (cur)
			{
				printf("%s\n", (char *) cur->data);
				cur = cur->next;
			}
			ft_lstclear(&head, NULL);
		}
	}
}

void	mock_free()
{
	puts("Free called, yeah !");
}

void	test_ft_strlen(const char *s)
{
	size_t	current = ft_strlen(s);
	size_t	expected = strlen(s);

	printf("ft_strlen(%s): Expected: %zu, current %zu %s\n", s, expected, current, expected == current ? "✅" : "❌");
}

void	test_ft_strcpy(char *dest, size_t dest_size, const char *src)
{
	char *ft_dest = malloc(dest_size);
	memcpy(ft_dest, dest, dest_size);

	char *std_dest = malloc(dest_size);
	memcpy(std_dest, dest, dest_size);

	char *ft_returned_dest = ft_strcpy(ft_dest, src);
	char *std_returned_dest = strcpy(std_dest, src);

	printf("strcpy(%s) = %s, ft_strcpy(%s) = %s - %s - %s\n", src, std_dest, src, ft_dest, strcmp(std_dest, ft_dest) == 0 ? "✅" : "❌", (ft_returned_dest == ft_dest) == (std_returned_dest == std_dest) ? "✅" : "❌");

	free(ft_dest);
	free(std_dest);
}

void	test_ft_strcmp(const char *s1, const char *s2)
{
	int current = ft_strcmp(s1, s2);
	int expected = strcmp(s1, s2);

	printf("strcmp(%s, %s): Expected: %d, current: %d - %s\n", s1, s2, expected, current, expected == current ? "✅" : "❌");
}

void	ft_lstclear(t_list **lst, void (*del)(void *))
{
	if (lst == 0 || *lst == 0)
		return ;
	if ((*lst)->next != 0)
		ft_lstclear(&(*lst)->next, del);
	if (del)
		del((*lst)->data);
	free(*lst);
	*lst = 0;
}
