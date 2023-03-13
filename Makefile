NAME		= libasm.a

ASMC		= nasm
ASMFLAGS	= -felf64

SRCS		= ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s \
			  ft_strdup.s

SRCS_BONUS	= $(addprefix bonus/, ft_atoi_base.s ft_list_push_front.s \
			  ft_list_size.s ft_list_sort.s ft_list_remove_if.s)

_OBJS		= $(SRCS:.s=.o)
OBJS		= $(addprefix build/, $(_OBJS))

_OBJS_BONUS	= $(SRCS_BONUS:.s=.o)
OBJS_BONUS	= $(addprefix build/, $(_OBJS_BONUS))

all:	$(NAME) bonus

$(NAME)	: $(OBJS)
	ar rc $(NAME) $(OBJS)

clean:
	rm -rf build/

fclean:	clean
	rm -f libasm.a

re	:	fclean all

bonus	: $(NAME) $(OBJS_BONUS)
	ar r $(NAME) $(OBJS_BONUS)


build/%.o	:	srcs/%.s
	@if [ ! -d $(dir $@) ]; then\
		mkdir -p $(dir $@);\
	fi
	$(ASMC) $(ASMFLAGS) $< -o $@

.PHONY	: all clean fclean re bonus
