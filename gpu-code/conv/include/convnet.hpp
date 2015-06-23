/// 
/// \file convnet.hpp
/// @brief

#ifndef CONVNET_H_
#define CONVNET_H_

#include <iostream>
#include "layer.hpp"

#define MAX_NUM_KERNEL 4096
#define MAX_NUM_THREAD 1024

template <typename Dtype>
class ConvNet : public TrainLayer<Dtype>{

private:

	Matrix<Dtype>* unrolled_x1;
	Matrix<Dtype>* unranged_y;
	Matrix<Dtype>* unrolled_x2;
	Matrix<Dtype>* ranged_dE_dx;
	Matrix<Dtype>* dE_db_tmp;
	Matrix<Dtype>* unrolled_conv;
	Matrix<Dtype>* ranged_w;
	Matrix<Dtype>* unranged_in;
	Matrix<Dtype>* padded_x;

	int _filt_pixs;
	int _conv_pixs;
	
	ConvParam* _cp;

public:
	ConvNet(ConvParam* cp);
	~ConvNet();

	void initCuda();
	void computeOutputs(Matrix<Dtype>* x);
	void computeDerivsOfPars(Matrix<Dtype>* x);
	void computeDerivsOfInput(Matrix<Dtype>* dE_dx);
	
};

#include "../src/convnet.cu"

#endif