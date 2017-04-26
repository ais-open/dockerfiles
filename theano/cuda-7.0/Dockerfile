# Start with cuDNN base image
FROM nvidia/cuda:7.0-cudnn4-devel-centos7
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

LABEL \
    VERSION="0.8.2-7.0" \
    RUN="nvidia-docker run -it appliedis/theano-cuda:0.8.2:7.0 nvidia-smi" \
    SOURCE="https://github.com/appliedis/dockerfiles" \
    DESCRIPTION="Prepackaged theano with CUDA on CentOS" \
    CLASSIFICATION="UNCLASSIFIED"

# Install git, wget, python-dev, pip, BLAS + LAPACK and other dependencies
RUN yum install -y epel-release && yum install -y \
  gcc-gfortran \
  git \
  wget \
  lapack-devel \
  openblas-devel \
  python-devel \
  python-pip \
  python-nose \
  numpy \
  scipy

# Set CUDA_ROOT
ENV CUDA_ROOT /usr/local/cuda/bin
# Install bleeding-edge Theano
RUN pip install theano==0.8.2
RUN pip install --upgrade pip six
# Set up .theanorc for CUDA
RUN echo "[global]\ndevice=gpu\nfloatX=float32\noptimizer_including=cudnn\n[lib]\ncnmem=0.1\n[nvcc]\nfastmath=True" > /root/.theanorc
