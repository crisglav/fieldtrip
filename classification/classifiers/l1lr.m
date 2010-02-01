classdef l1lr < classifier
%L1 regularized logistic regression using Mark Schmidt's L1General package
%
%   Copyright (c) 2009, Marcel van Gerven


    properties

        lambda = 1;
        
    end

    methods
      
       function obj = l1lr(varargin)
                  
           obj = obj@classifier(varargin{:});
                      
       end
       
       function p = estimate(obj,data,design)
                 
         if design.nunique ~= 2, error('L1LR expects binary class labels'); end

         if obj.verbose
           fprintf('\nComputing L1-Regularized Logistic Regression Coefficients...\n');
         end
         
         design = design.X;
        
         % foolproof
         if all(design(:,1) == 1)
           p.model = -inf;
         elseif all(design(:,1) == 2)
           p.model = inf;
         else
           
           X = [ones(data.nsamples,1) data.X];
           
           design = 2*design - 3; % convert to -1 / + 1
           
           lambdas = obj.lambda*ones(data.nfeatures+1,1);
           lambdas(1) = 0; % Do not penalize bias variable
           
           funObj = @(w)LogisticLoss(w,X,design);
           w_init = zeros(data.nfeatures+1,1);
            
           opt.verbose = 0;
           p.model = L1GeneralProjection(funObj,w_init,lambdas,opt);
         end

       end

       function post = map(obj,data)

         if isinf(obj.params.model(1)) 
           if obj.params.model < 0
            post = dataset([ones(data.nsamples,1) zeros(data.nsamples,1)]);
           else
             post = dataset([zeros(data.nsamples,1) ones(data.nsamples,1)]);
           end
         else
           post = 1 ./ (1 + exp([ones(data.nsamples,1) data.X] * obj.params.model));
           post = dataset([post 1 - post]);
         end
         
       end              
       
       function [m,desc] = getmodel(obj)
         % return the parameters wrt a class label in some shape 
         
           m = {obj.params.model(2:end)'}; % ignore bias term
           desc = {'unknown'};
           
       end
       
    end
end 
