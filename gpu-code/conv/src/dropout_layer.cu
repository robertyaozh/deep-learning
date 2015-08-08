///
/// \file dropout_layer.cu
/// @brief


using namespace std;

template <typename Dtype>
DropoutLayer<Dtype>::DropoutLayer(Param* p){

	this->_p           = p;
	this->_layer_type			= DROPOUT;
}

template <typename Dtype>
DropoutLayer<Dtype>::~DropoutLayer() {
	delete  this->_y; 
	delete  this->_dE_dy;
	delete  _drop_record;
	delete  _drop_rand_probs;

}

template <typename Dtype>
void DropoutLayer<Dtype>::initCuda() {


	ConnectType ct = this->_p->getConnectType();
	int col;
	if(ct == PARAM_CONNECT_TYPE_LOCAL)
		col = pow(this->_p->getOutSize(), 2) * this->_p->getOutChannel(); 
	else if(ct == PARAM_CONNECT_TYPE_FULL)
		col = this->_p->getNumOut();
		
	this->_y             = new Matrix<Dtype>(_p->getMinibatchSize(), col);
	this->_dE_dy         = new Matrix<Dtype>(this->_y);
	_drop_record		 = new Matrix<int>(_p->getMinibatchSize(), col);
	_drop_rand_probs     = new Matrix<curandState>(_p->getMinibatchSize(), col);
	_is_set_up 			 = false;
}

template <typename Dtype>
void DropoutLayer<Dtype>::computeOutputs(Matrix<Dtype>* x){ 
//	x->reValue(32);
//	x->showValue("data");
	
	x->applyDropout(this->_y, _drop_record, _drop_rand_probs, _is_set_up);
	
	if(_is_set_up == false)
		_is_set_up = true;
	
//	_drop_record->showValue("record");	
//	this->_y->showValue("yj1");

}

template <typename Dtype>
void DropoutLayer<Dtype>::computeDerivsOfInput(Matrix<Dtype>* dE_dx){

//this->_dE_dy->reValue(1.0f);
	
	this->_dE_dy->applyRelu(dE_dx, _drop_record, false);

//dE_dx->showValue("dropout_dedx");
}


