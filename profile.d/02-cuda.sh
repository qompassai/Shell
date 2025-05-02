export CUDAToolkit_ROOT=/opt/cuda
export CUDA_HOME=/opt/cuda
export PATH="$PATH:/opt/cuda/bin"
export CUDA_NVCC_EXECUTABLE="sccache /opt/cuda/bin/nvcc"
export PATH="$PATH:/opt/cuda/bin"
if [[ ":$LD_LIBRARY_PATH:" != *":/opt/cuda/lib64:"* ]]; then
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/cuda/lib64"
fi
if [[ ":$LIBRARY_PATH:" != *":/opt/cuda/lib64:"* ]]; then
    export LIBRARY_PATH="$LIBRARY_PATH:/opt/cuda/lib64"
fi
export OPTIX_INSTALL_DIR=/opt/optix-sdk
export PATH=$PATH:$OPTIX_INSTALL_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPTIX_INSTALL_DIR/lib64
export CUDA_VISIBLE_DEVICES=0,1,2
export PATH="$OPTIX_SDK_DIR/bin:$PATH"
