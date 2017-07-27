/*  
    Version: 1.0
    
    A C++ implementation of Dijkstra's algorithm using binary heap, interfaced 
    with Matlab, to be compiled with mex. Usage related details can be found 
    near the mexFunction definition towards the bottom of the file.
    
    Copyright (C) 2012  M Seetha Ramaiah (msram@cse.iitk.ac.in)
                        URL: http://msram.co.nr/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    See http://www.gnu.org/licenses/gpl.html for more details regarding
    the terms of use.
 */
 
#include <iostream>
#include <iomanip>
#include <limits>
#include <time.h>
#include <string.h>
#include <stdio.h>

#include "mex.h"

// Change the following definitions to change the range of acceptable values 
#define INT_TYPE            int32_T
#define INT_CLASS           mxINT32_CLASS
#define INT_TYPE_STRING     "int32"

#define REAL_TYPE           double
#define REAL_CLASS          mxDOUBLE_CLASS
#define REAL_TYPE_STRING    "double"

#define INFINITY            numeric_limits<REAL_TYPE >::infinity()
#define NONE                -1

using namespace std;

template <class T> void swapT( T& a, T& b )
{
  T c(a); a=b; b=c;
}

class MinHeap
{
    private:
        INT_TYPE     maxSize;    // Maximum size of the heap; depends on the application; equal to |V| for Dijkstra's algorithm.
        INT_TYPE     N;          // Current size of the heap;
        INT_TYPE     *keys;      // to store vertices
        REAL_TYPE    *values;    // to store dist for each vertex; heap property is maintained w.r.t. these values.
        INT_TYPE     *key2ind;   // reverse map from key to index in the heap; needed to keep decreaseKey O(log N).
        
        void shiftUp(INT_TYPE  index);   // After a pop operation, shift the nodes up to maintain the min-heap property
        void shiftDown(INT_TYPE  index); // After a push operation, shift the nodes down to maintain the min-heap property
        
    public:
        
        void init(INT_TYPE  n);                            // Construct heap.
        bool push(INT_TYPE  key, REAL_TYPE   val);            // Insert a (key, val) record into heap; maintain heap property w.r.t. val.
        bool pop(INT_TYPE  *key, REAL_TYPE   *val);           // Remove the (key, val) pair with minimum val.
        bool decreaseKey(INT_TYPE  key, REAL_TYPE   newVal);  // Change the value of a key to something else.
        bool min(INT_TYPE  *key, REAL_TYPE   *val);           // Return the (key, val) pair of the root node.
        bool isEmpty();                             // Tell whether the heap is empty.
        void display();                             // Display the heap contents.
        ~MinHeap();                                 // Destroy heap.
};

class Graph
{
    private:
        INT_TYPE     N;      // Number of nodes in the graph
        INT_TYPE     *deg;   // Degree of each node in the graph
        REAL_TYPE    **w;    // cost-list for each node to its neighbors    
        INT_TYPE     **adj;  // adjacency list for each node
        
    public:
        void init(INT_TYPE  n, INT_TYPE  *degree, INT_TYPE  **A, REAL_TYPE   **cost)
        {
            adj = A;
            w   = cost;
            deg = degree;
            N   = n;
        }
        
        void dijkstra(INT_TYPE  src, REAL_TYPE   *d, INT_TYPE  *p);
};

void MinHeap :: init(INT_TYPE  size)
{
    maxSize = size;
    N       = 0;
    
    keys    = (INT_TYPE *) mxCalloc(size, sizeof(INT_TYPE));
    values  = (REAL_TYPE *) mxCalloc(size, sizeof(REAL_TYPE));
    key2ind = (INT_TYPE *) mxCalloc(size, sizeof(INT_TYPE));
    
    for(INT_TYPE  i=0; i<maxSize; i++)
    {
        keys[i]     = key2ind[i]  = -1;
        values[i]   = -1;
    }
}

MinHeap :: ~MinHeap()
{
    mxFree(keys);
    mxFree(key2ind);
    mxFree(values);
}

bool MinHeap :: isEmpty()
{
    return N == 0;
}

void MinHeap :: shiftUp(INT_TYPE  index)
{
    INT_TYPE  j = index;
    
    while(j > 0)
    {
        INT_TYPE  i = (j-1)/2;
        if(values[j] < values[i])
        {
            swapT(values[j], values[i]);
            swapT(keys[j], keys[i]);
            
            key2ind[keys[i]] = i;
            key2ind[keys[j]] = j;
            
            j = i;
        }
        else
            break;
    }
}

void MinHeap :: shiftDown(INT_TYPE  index)
{
    INT_TYPE  i = index;
    
    while(i < N/2)
    {
        INT_TYPE  leftC  = 2*i+1;
        INT_TYPE  rightC = 2*i+2;
        
        INT_TYPE  j = leftC; // set j to index of min(values[leftC], values[rightC]);
        if(values[rightC] < values[leftC])
            j = rightC;
        
        if(values[j] < values[i])
        {
            swapT(values[j], values[i]);
            swapT(keys[j], keys[i]);
            
            key2ind[keys[i]] = i;
            key2ind[keys[j]] = j;
            
            i = j;
        }
        else
            break;
    }
}

bool MinHeap :: push(INT_TYPE  key, REAL_TYPE   val)
{
    if( N == maxSize )
    {
        // MinHeap size exceeds maxSize.
        return false;
    }
    
    key2ind[key] = N;
    keys[N] = key;
    values[N] = val;
    
    shiftUp(N);
    
    N++;
    return true;
}

bool MinHeap :: pop(INT_TYPE  *key, REAL_TYPE   *val)
{
    if( N == 0 )
        return false;
        
    *key = keys[0];
    *val = values[0];
    
    keys[0]     = keys[N-1];
    values[0]   = values[N-1];
    N--;
    
    key2ind[*key] = -1;
    shiftDown(0);
    key2ind[keys[0]] = 0;
    
    return true;    
}

bool MinHeap :: decreaseKey(INT_TYPE  key, REAL_TYPE   newVal)
{
    if(values[key2ind[key]] < newVal) // new value has to be less than the current value.
        return false;
    
    values[key2ind[key]] = newVal;
    shiftUp(key2ind[key]);
    
    return true;
}
bool MinHeap :: min(INT_TYPE  *key, REAL_TYPE   *val)
{
    if( N == 0 )
        return false;
    
    *key = keys[0];
    *val = values[0];
    return true;
}

void MinHeap :: display()
{
    INT_TYPE  i;
    
    mexPrintf("\tHeap: ");
    for(i=0; i<N; i++)
    {
        // This line may have to be changed when the data types are changed
        mexPrintf(" (%ld, %ld, %lf); \n", (INT_TYPE)key2ind[keys[i]], (INT_TYPE)keys[i], (REAL_TYPE)values[i]);
    }
    
    mexPrintf("\n");
}


void Graph :: dijkstra(INT_TYPE  source, REAL_TYPE *dist, INT_TYPE  *prev)
{
    MinHeap *heap = (MinHeap *) mxMalloc(sizeof(MinHeap));
    heap->init(N);
    
    // Initialize dist, prev and heap
    for(INT_TYPE  v=0; v<N; v++)
    {
        dist[v] = INFINITY;
        prev[v] = NONE;
        heap->push(v, INFINITY);
    }
    
    dist[source] = 0;
    heap->decreaseKey(source, 0);   // Insert source in heap, with dist value = 0
    
    INT_TYPE     u;
    REAL_TYPE    d;
    
    while(heap->pop(&u, &d))
    {
        if(d == INFINITY)
            break;
        
        for(INT_TYPE  k=0; k<deg[u]; k++)
        {
            INT_TYPE     v   = adj[u][k]-1;
            
            REAL_TYPE    c   = w[u][k];
            REAL_TYPE    alt = dist[u] + c;
            if(alt < dist[v])
            {
                dist[v] = alt;
                prev[v] = u;
                heap->decreaseKey(v, alt);
            }
        }
        // heap->display();
    }
    
    mxFree(heap);
}

/*
 * Input:
 *      Three arrays: adj, cost, src
 *      prhs should point to 3 arrays: 
 *
 *          adj : a cell array specifying the node connectivity of the graph as an adjacency list;
 *              : each row may contain different number of columns.
 *              : ragged array of INT_TYPE
 *
 *          cost: another cell array of corresponding edges costs.
 *              : ragged array of REAL_TYPE
 *
 *          src : source node;
 *              : value of INT_TYPE
 *
 * Output:
 *      Two arrays: dist and prev
 *      plhs should point to 2 arrays:
 *          
 *          dist: distance to each node from the source node via the shortest path.
 *          
 *          prev: previous node of each node on the shortest path from source node.
 *              : contents are of type int32
 *
 */
 
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Check for proper number of arguments.
    if(nrhs != 3 || nlhs != 2) {
        mexErrMsgTxt("Need exactly 3 input arguments and 2 output arguments.\n"
                     "Usage:\n\t[dist, prev] = dijkstra_bheap(adj, cost, src)\n"
                     "\n\twhere\n\n\t\tadj : adjacency list; must be supplied as a cell array of " INT_TYPE_STRING " type values."
                     "\n\t\tcost: cost list; must be supplied as a cell array of " REAL_TYPE_STRING " type values."
                     "\n\t\tsrc : source node; must be supplied as an " INT_TYPE_STRING " type value.\n"
                     "\n\t\tdist: dist values; distances from the source node by the shortest path."
                     "\n\t\tprev: previous nodes for each node on the shortest path.\n");
    }
    
    clock_t t1, t2;
    t1 = clock();
    
    const mxArray *cell_array_ptr = prhs[0];
    if(strcmp(mxGetClassName(mxGetCell(cell_array_ptr, 0)), INT_TYPE_STRING))
    {
        char errorMessage[1024];
        sprintf(errorMessage, "Wrong data type for adjacency list!\n Expected: " INT_TYPE_STRING "\n Given: %s", 
                              mxGetClassName(mxGetCell(cell_array_ptr, 0)));
        mexErrMsgTxt(errorMessage);
    }
    
    // mexPrintf("Sizeof(int32_T *) = %d\n", sizeof(INT_TYPE *));
    
    INT_TYPE i, j, N, M;
    
    const mxArray *cell_element_ptr1, *cell_element_ptr2;
    
    INT_TYPE    nNodes  = mxGetNumberOfElements(cell_array_ptr);
    INT_TYPE    *deg    = (INT_TYPE *) mxCalloc(nNodes, sizeof(INT_TYPE));
    INT_TYPE    **adj   = (INT_TYPE **) mxCalloc(nNodes, sizeof(INT_TYPE *));
    REAL_TYPE   **cost  = (REAL_TYPE **) mxCalloc(nNodes, sizeof(REAL_TYPE *));
    
    // mexPrintf("nNodes = %d\n", nNodes);
    
    for (i=0; i<nNodes; i++)  
    {
        cell_element_ptr1 = mxGetCell(prhs[0], i);
        cell_element_ptr2 = mxGetCell(prhs[1], i);
        
        M = mxGetM(cell_element_ptr1); // M = 1 always for adjacency lists
        N = mxGetN(cell_element_ptr1); // N = degree of the current node
        
        deg[i]  = N;
        adj[i]  = (INT_TYPE *)  mxGetPr(cell_element_ptr1); // (INT_TYPE *) mxCalloc(deg[i], sizeof(INT_TYPE));
        cost[i] = (REAL_TYPE *) mxGetPr(cell_element_ptr2); // (REAL_TYPE *) mxCalloc(deg[i], sizeof(REAL_TYPE));
    }
    
    // mexPrintf("%s\n", mxGetClassName(prhs[2]));
    
    REAL_TYPE *st = (REAL_TYPE *) mxGetPr(prhs[2]);
    INT_TYPE source = (INT_TYPE) *st - 1;
    
    // mexPrintf("Source: %ld\n", source);
    
    plhs[0] = mxCreateNumericMatrix(1, nNodes, REAL_CLASS, mxREAL);
    plhs[1] = mxCreateNumericMatrix(1, nNodes, INT_CLASS, mxREAL);
    
    
    REAL_TYPE  *dist = (REAL_TYPE *) mxGetPr(plhs[0]);
    INT_TYPE   *prev = (INT_TYPE *) mxGetPr(plhs[1]);
    
    Graph *G = (Graph *) mxCalloc(1, sizeof(Graph));
    G->init(nNodes, deg, adj, cost);
    
    G->dijkstra(source, dist, prev);
    
    for(i=0; i<nNodes; i++)
        if(prev[i] != NONE)
            prev[i]++;
    
    mxFree(G); 
    mxFree(deg);
    mxFree(adj);
    mxFree(cost);
    
    t2 = clock();    
    //mexPrintf("Time spent inside dijkstra_bheap.cpp: %.2f ms.\n", (t2-t1)*1000.0/CLOCKS_PER_SEC);
}
