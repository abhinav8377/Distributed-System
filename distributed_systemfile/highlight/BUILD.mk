#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#── vi: set noet ft=make ts=8 sw=8 fenc=utf-8 :vi ────────────────────┘

PKGS += distributed_systemfile_HIGHLIGHT

distributed_systemfile_HIGHLIGHT_FILES := $(wildcard distributed_systemfile/highlight/*)
distributed_systemfile_HIGHLIGHT_HDRS = $(filter %.h,$(distributed_systemfile_HIGHLIGHT_FILES))
distributed_systemfile_HIGHLIGHT_INCS = $(filter %.inc,$(distributed_systemfile_HIGHLIGHT_FILES))
distributed_systemfile_HIGHLIGHT_SRCS_C = $(filter %.c,$(distributed_systemfile_HIGHLIGHT_FILES))
distributed_systemfile_HIGHLIGHT_SRCS_CPP = $(filter %.cpp,$(distributed_systemfile_HIGHLIGHT_FILES))
distributed_systemfile_HIGHLIGHT_SRCS_GPERF = $(filter %.gperf,$(distributed_systemfile_HIGHLIGHT_FILES))
distributed_systemfile_HIGHLIGHT_SRCS_GPERF_C = $(distributed_systemfile_HIGHLIGHT_SRCS_GPERF:%.gperf=o/$(MODE)/%.c)

distributed_systemfile_HIGHLIGHT_SRCS =							\
	$(distributed_systemfile_HIGHLIGHT_SRCS_C)						\
	$(distributed_systemfile_HIGHLIGHT_SRCS_CPP)						\
	$(distributed_systemfile_HIGHLIGHT_SRCS_GPERF)					\

distributed_systemfile_HIGHLIGHT_OBJS =							\
	$(distributed_systemfile_HIGHLIGHT_SRCS_C:%.c=o/$(MODE)/%.o)				\
	$(distributed_systemfile_HIGHLIGHT_SRCS_CPP:%.cpp=o/$(MODE)/%.o)			\
	$(distributed_systemfile_HIGHLIGHT_SRCS_GPERF_C:%.c=%.o)				\

o/$(MODE)/distributed_systemfile/highlight/highlight.a: $(distributed_systemfile_HIGHLIGHT_OBJS)

$(distributed_systemfile_HIGHLIGHT_OBJS): distributed_systemfile/highlight/BUILD.mk

o/$(MODE)/distributed_systemfile/highlight/highlight_test:					\
		o/$(MODE)/distributed_systemfile/highlight/highlight_test.o			\
		o/$(MODE)/distributed_systemfile/highlight/highlight.a			\

o/$(MODE)/distributed_systemfile/highlight/highlight_c_test:					\
		o/$(MODE)/distributed_systemfile/highlight/highlight_c_test.o		\
		o/$(MODE)/distributed_systemfile/highlight/highlight_c.o			\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_c.o			\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_c_constant.o		\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_c_type.o		\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_c_pod.o		\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_cpp.o			\

o/$(MODE)/distributed_systemfile/highlight/highlight_python_test:				\
		o/$(MODE)/distributed_systemfile/highlight/highlight_python_test.o		\
		o/$(MODE)/distributed_systemfile/highlight/highlight_python.o		\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_python.o		\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_python_builtin.o	\
		o/$(MODE)/distributed_systemfile/highlight/is_keyword_python_constant.o	\

.PHONY: o/$(MODE)/distributed_systemfile/highlight
o/$(MODE)/distributed_systemfile/highlight:							\
		$(distributed_systemfile_HIGHLIGHT_SRCS_GPERF_C)				\
		o/$(MODE)/distributed_systemfile/highlight/highlight.a			\
		o/$(MODE)/distributed_systemfile/highlight/highlight_c_test.runs		\
		o/$(MODE)/distributed_systemfile/highlight/highlight_python_test.runs	\
		o/$(MODE)/distributed_systemfile/highlight/highlight_test.runs		\
