classdef gnb < classifier
%GNB generalized naive Bayes classifier
%
% For instance, we can use exponential distributions
%
% gnb('conditional','exponential') 
%
% or truncated gaussians
%
% truncgauss = @(x,mu,sigma)(normpdf(x,mu,sigma)./(normcdf(500,mu,sigma)-normcdf(0,mu,sigma)));
% truncmle = @(x)(mle(x,'pdf',truncgauss,'start', [nanmean(x) nanstd(x)],'lower', [0 0]));
% 
% gnb('conditional',truncgauss,'mle',truncmle)
% 
% In the former case, we can specify the conditional as a string (see code for more options). 
% In the latter case, both the conditional and maximum likelihood estimates are functions that 
% need to be specified. Check Matlab's mle function documentation for
% options.
%
% PARAMETERS:
%   params 
%   nclasses
%   priors
%
%   Copyright (c) 2008, Marcel van Gerven


    properties
      
      
      conditional = 'normal'; % existing pdf or function handle
      mle; % can be used to specify custom mle function
    
    end
    
    methods
      
      function obj = gnb(varargin)
        
        obj = obj@classifier(varargin{:});
      end
      
      function p = estimate(obj,data,design)
        
        p.nclasses = design.nunique;
        nfeatures = data.nfeatures;
        
        X = data.X;
        design = design.X;
        
        % estimate class priors
        p.priors = zeros(p.nclasses,1);
        for j=1:p.nclasses
          p.priors(j) = sum(design(:,1)==j)/size(design,1);
        end
        
        % parameters per class/feature pair
        p.params = cell(p.nclasses,nfeatures);
        
        if ~isa(obj.conditional,'function_handle')
          
          % estimate class-conditional means
          for j=1:nfeatures
            for k=1:p.nclasses
              p.params{k,j} = mle(X(design(:,1) == k,j),'distribution',lower(obj.conditional));
            end
          end
          
        else
          
          if isempty(obj.mle)
            
            for j=1:nfeatures
              for k=1:p.nclasses
                
                p.params{k,j} = mle(X(design(:,1) == k,j),'pdf',obj.conditional);
              end
            end
            
          else
            
            for j=1:nfeatures
              for k=1:p.nclasses
                
                p.params{k,j} = obj.mle(X(design(:,1) == k,j));
              end
            end
            
          end
        end
        
      end
      
      function post = map(obj,data)
        
        p = obj.params.params;
        
        X = data.X;
        
        post = nan(size(X,1),obj.params.nclasses);
        
        nparams = length(p{1,1});
        
        for m=1:size(post,1) % iterate over examples
          
          for c=1:obj.params.nclasses
            
            % compute conditional
            conditional = zeros(1,data.nfeatures);
            
            if ~isa(obj.conditional,'function_handle')
              
              for j=1:data.nfeatures
                if nparams == 1
                  conditional(j) = pdf(obj.conditional,X(m,j),p{c,j}(1));
                elseif nparams == 2
                  conditional(j) = pdf(obj.conditional,X(m,j),p{c,j}(1),p{c,j}(2));
                else
                  conditional(j) = pdf(obj.conditional,X(m,j),p{c,j}(1),p{c,j}(2),p{c,j}(3));
                end
              end
              
            else
              
              for j=1:data.nfeatures
                if nparams == 1
                  conditional(j) = obj.conditional(X(m,j),p{c,j}(1));
                elseif nparams == 2
                  conditional(j) = obj.conditional(X(m,j),p{c,j}(1),p{c,j}(2));
                else
                  conditional(j) = obj.conditional(X(m,j),p{c,j}(1),p{c,j}(2),p{c,j}(3));
                end
              end
              
            end
            
            % degenerate cases
            if ~obj.params.priors(c) || any(isinf(conditional)) || ~all(conditional)
              post(m,c) = 0;
              break
            end
            
            % compute probability
            post(m,c) = log(obj.params.priors(c)) + mynansum(log(conditional));
            
          end
          
          % compute normalizing term using log-sum-exp trick
          
          mx = max(post(m,:));
          
          nt = 0;
          for c=1:obj.params.nclasses
            nt = nt + exp(post(m,c) - mx);
          end
          nt = log(nt) + mx;
          
          % normalize
          post(m,:) = exp(post(m,:) - nt);
          
        end
        
        post = dataset(post);
        
      end
      
    end
end
