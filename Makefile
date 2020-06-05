PROJ_DIR := $(CURDIR)
SRC_DIR := $(PROJ_DIR)/source
BUILD_DIR := $(PROJ_DIR)/build

SDK_PATH := $(PROJ_DIR)/AnalyzerSDK
SDK_LIB := $(SDK_PATH)/lib/libAnalyzer64.so

CC := gcc

TARGET := QSPIAnalyzer.so

SRCS := $(SRC_DIR)/QSPIAnalyzerCommands.cpp \
    $(SRC_DIR)/QSPIAnalyzerResults.cpp \
    $(SRC_DIR)/QSPISimulationDataGenerator.cpp \
    $(SRC_DIR)/QSPIAnalyzer.cpp \
    $(SRC_DIR)/QSPIAnalyzerSettings.cpp

OBJS := $(subst $(SRC_DIR), $(BUILD_DIR), $(addsuffix .o, $(basename $(SRCS))))

INCLUDES := -I$(SRC_DIR) -I$(SDK_PATH)/include

CXXFLAGS := -O3 -Wall -Wextra -std=c++14 -fPIC -x c++

LD_LIBRARIES := -lsupc++ -lstdc++ $(SDK_LIB)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "[ CXX ] $(notdir $<)"
	@mkdir -p $(@D)

	@$(CC) -c $(CXXFLAGS) $(INCLUDES) -MD -MP -MF "$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -o "$@" "$<"

# Link ELF
$(TARGET): $(OBJS)
	@echo "[ LD ] $(notdir $@)"
	@mkdir -p $(@D)
	@$(CC) -shared -o "$@" $^ $(LD_LIBRARIES)
	@strip "$@"

.PHONY: clean

clean:
	@rm -rf $(BUILD_DIR)
