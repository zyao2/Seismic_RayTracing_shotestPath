classdef heap < handle
	% See C++ code for explanations
	% NB: The formulae for indices for child/parent nodes
	% are slightly different in C++ since C++ arrays start at 0.
	
	properties
		% Arrays
		Times; % Holds tentative T values
		H2T;  % Pointers from the heap to T
		T2H;  % Pointers from T to the heap
        node; % Pointers to previous point
		
		% Counters
		heapCount;
	end
	
	methods
		% Constructor
		function obj = heap(N)
			obj.heapCount = 0;
			obj.Times = zeros(1,N);
			obj.H2T  = zeros(1,N);
			obj.T2H  = zeros(1,N);
            obj.node  = zeros(1,N);
		end		
	end
	
	methods
		
		function outInd = parentInd(~, inInd)
			outInd = floor(inInd/2);
		end
		
		function outInd = leftChildInd(~, inInd)
			outInd = 2*inInd;
		end
		
		function outInd = rightChildInd(~, inInd)
			outInd = 2*inInd + 1;
		end
		
		function outInd = lastParentInd(obj)
			outInd = floor(obj.heapCount/2);
		end
		
	
		
		function outInd = checkHeapProperty(obj, pInd)
		% Checks that the heap property is satisfied, from pInd and
		% down. Returns index in heap of the parent of the first
		% "unruly" child. Only returns the first such found.
		% Otherwise, returns 0.
		% Heap property: parent < child1, child2 for all parent nodes
			lChild = obj.leftChildInd(pInd);
			rChild = lChild + 1;
			
			outInd = 0;
			
			if((lChild <= obj.heapCount) && ...
					(obj.Times(lChild) < obj.Times(pInd)))
					outInd = pInd;
					return;
			end
			if((rChild <= obj.heapCount) && ...
					(obj.Times(rChild) < obj.Times(pInd)))
				outInd = pInd;
				return;
			end
			
			if ((outInd==0) &&  (lChild <= obj.lastParentInd()))
				outInd = obj.checkHeapProperty(lChild);
			end
			if ((outInd==0) && (rChild <= obj.lastParentInd()))
				outInd = obj.checkHeapProperty(rChild);
			end
		end

		
		
		function swapElements(obj,Ind1,Ind2)
			if(Ind1==Ind2)
				return;
			end
			
			% Swap Times
			tmp = obj.Times(Ind1);
			obj.Times(Ind1) = obj.Times(Ind2);
			obj.Times(Ind2) = tmp;
			
			% Swap T2H values
			% NB: Must come before H2T swaps
			obj.T2H(obj.H2T(Ind1)) = Ind2;
			obj.T2H(obj.H2T(Ind2)) = Ind1;
			
			% Swap H2T elems
			tmp = obj.H2T(Ind1);
			obj.H2T(Ind1) = obj.H2T(Ind2);
			obj.H2T(Ind2) = tmp;
            
            % Swap node elems
			tmp = obj.node(Ind1);
			obj.node(Ind1) = obj.node(Ind2);
			obj.node(Ind2) = tmp;
		end
		
		function upHeap(obj, Ind)
			while(Ind>1)
				pInd = obj.parentInd(Ind);
				if (obj.Times(Ind) < obj.Times(pInd))
					obj.swapElements(Ind,pInd);
					Ind = pInd;
				else
					break;
				end
			end
		end
		
		function downHeap(obj, Ind)
			if (obj.heapCount < 2)
				return;
			end
			
			while (Ind <= obj.lastParentInd())
				child1 = obj.leftChildInd(Ind);
				child2 = obj.rightChildInd(Ind);
				minChild = Ind;
				
				if (obj.Times(child1) < obj.Times(Ind))
					minChild = child1;
				end
				if( (child2 <= obj.heapCount) && ...
						(obj.Times(child2) < obj.Times(minChild)))
					minChild = child2;
				end
				
				if (minChild ~= Ind)
					obj.swapElements(Ind,minChild);
					Ind = minChild;
				else
					break;
				end
			end
		end
		
		
		
		function bool = isInHeap(obj, Ind)
			bool = (obj.T2H(Ind) > 0);
		end
		
		function insert(obj, time, Ind, node_b)
			obj.heapCount = obj.heapCount + 1;		
			obj.Times(obj.heapCount) = time;
			obj.H2T(obj.heapCount)   = Ind;
            obj.node(obj.heapCount)   = node_b;
			obj.T2H(Ind)			 = obj.heapCount;
			
			obj.upHeap(obj.heapCount);
		end
			
		function update(obj, time, node_b, Ind)
            tt=obj.Times(obj.T2H(Ind));
            if(time<tt)       
                obj.Times(obj.T2H(Ind)) = time;
                obj.node(obj.T2H(Ind)) = node_b;
                obj.upHeap(obj.T2H(Ind));
            end
		end
		
		function [time, Ind, node_b] = getSmallest(obj)
			time = obj.Times(1);
			Ind  = obj.H2T(1);
            node_b=obj.node(1);
			
			obj.swapElements(1,obj.heapCount);
			
			obj.heapCount = obj.heapCount - 1;
			
			obj.downHeap(1);
		end
	end
	
end