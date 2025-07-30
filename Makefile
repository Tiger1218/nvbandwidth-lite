#
# Makefile
# Tiger1218, 2025-07-30 13:44
#
# 编译器
# 使用 nvcc 作为主编译器/链接器
NVCC := nvcc

# 可执行文件的名称
TARGET := nvbandwidth-lite

# 源文件
# 自动查找所有 .cu 文件，但这里我们只有一个
SRCS := nvbandwidth-lite.cu

# 根据源文件自动生成目标文件 (.o) 的名称
OBJS := $(SRCS:.cu=.o)

# C++ 标准
# 使用 C++17 标准，确保现代 C++ 特性可用
CPP_STANDARD := -std=c++17

# 编译标志
# -O3:        最高级别优化
# -Xcompiler: 将后面的标志传递给主机编译器 (如 gcc/g++)
NVCCFLAGS := -O3 $(CPP_STANDARD) -Xcompiler "-fPIC"

# 目标 GPU 架构
# 这里为几个常见的现代架构（Turing, Ampere, Hopper）生成代码。
# 你可以根据你的 GPU 修改或添加。
# compute_XX 是 PTX JIT 编译的虚拟架构
# sm_XX 是 SASS 编译的真实架构
ARCH_FLAGS := -gencode arch=compute_75,code=sm_75 \
              -gencode arch=compute_86,code=sm_86 \
              -gencode arch=compute_90,code=sm_90

# 最终传递给 nvcc 的完整编译标志
FULL_NVCCFLAGS := $(NVCCFLAGS) $(ARCH_FLAGS)

# 链接库
# nvcc 在链接时会自动包含 CUDA runtime (cudart)，所以通常无需额外指定
LDLIBS :=

# --- 规则 ---

# 默认规则: 编译所有内容
all: $(TARGET)

# 链接规则: 从目标文件生成可执行文件
$(TARGET): $(OBJS)
	@echo "==> Linking to create executable: $@"
	$(NVCC) -o $@ $^ $(LDLIBS)

# 编译规则: 从 .cu 源文件生成 .o 目标文件
# $<: 第一个依赖项 (源文件)
# $@: 规则的目标 (目标文件)
%.o: %.cu
	@echo "==> Compiling source: $<"
	$(NVCC) $(FULL_NVCCFLAGS) -c -o $@ $<

# 清理规则: 删除所有生成的文件
clean:
	@echo "==> Cleaning up generated files"
	rm -f $(TARGET) $(OBJS)

# 声明 "all" 和 "clean" 为伪目标，因为它们不代表真实文件
.PHONY: all clean


# vim:ft=make
#
