function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% part 1:
% Y = eye(num_labels);
% a1 = [ones(m,1),X];
% Z2 = a1 * Theta1';
% a2 = [ones(m,1), sigmoid(Z2)];
% Z3 = a2 * Theta2';
% a3 = sigmoid(Z3);
% for i = 1:m
%     for k = 1 : num_labels
%         if(y(i) == k)
%             yy = Y(:,y(i));
%             J = J + (log(a3(i,:)) * yy + log(1 - a3(i,:)) * (1 - yy));        
%         end
%     end
% end
% J = -1/m * J;

% part 2
Y = eye(num_labels);
for i = 1 : m
    a1 = [1, X(i,:)];
    Z2 = a1 * Theta1';
    a2 = [1, sigmoid(Z2)];
    Z3 = a2 * Theta2';
    a3 = sigmoid(Z3);
    yy = Y(y(i),:);
    
    delta3 = a3 - yy;
    
    delta2 = Theta2' * (delta3 .* sigmoidGradient(Z2))';
    delta2 = delta2(1:end-1);

    Theta1_grad = Theta1_grad + delta2 * a1;
    Theta2_grad = Theta2_grad + delta3' * a2;
end


Theta1_grad = 1/m * Theta1_grad;
Theta2_grad = 1/m * Theta2_grad;


% part 3 
tempJ = 0;
[row_theta1, col_theta1] = size(Theta1);
[row_theta2, col_theta2] = size(Theta2);

for j = 1 : row_theta1
    for k = 1 : col_theta1-1
        tempJ = tempJ + Theta1(j,k+1)^2;
    end
end

for j = 1 : row_theta2
    for k = 1 : col_theta2-1
        tempJ = tempJ + Theta2(j,k+1)^2;
    end
end

J = J + lambda/(2*m) * tempJ;


















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
