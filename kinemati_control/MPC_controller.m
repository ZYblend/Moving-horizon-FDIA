function z_full = MPC_controller(z,zd,H,Aineq,bineq,L,n_states, n_int,Ts,d)

D_bar = @(N,n)[zeros((N-1)*n,n), eye((N-1)*n)];
D_under = @(N,n)[eye((N-1)*n),zeros((N-1)*n,n)];
E = kron([1, zeros(1,L)],eye(n_states));
% A = @(z) [1 0 0;
%      -Ts*sin(z(1))-d*Ts*cos(z(1)) 1 0;
%      Ts*cos(z(1))-d*Ts*sin(z(1)) 0 1];
A = @(z) [1 0 0;
     0 1 0;
     0 0 1];
B = @(z) Ts*[0 1;
          cos(z(1)) -d*sin(z(1));
          sin(z(1)) d*cos(z(1))];
Aeq = @(z) [D_bar(L+1,n_states)-kron(eye(L),A(z))*D_under(L+1,n_states) -kron(eye(L),B(z)) zeros(L*n_states,n_int*L);
            E zeros(n_states,n_int*L) zeros(n_states,n_int*L)];
beq = [zeros(L*n_states,1); z];

z_full(:) = quadprog(H,zeros(n_states*(L+1)+n_int*2*L,1),Aineq,bineq,Aeq(zd),beq);