function writeDoublePendulumDynamics(f,M)

%This function writes the dynamics file for the double pendulum.

filename = 'doublePendulumDynamics';

comments{1} = ['DZ = ' upper(filename) '(T,Z,P)'];
comments{2} = ' ';
comments{3} = 'FUNCTION:  This function computes the dynamics of a double';
comments{4} = '    pendulum, and is designed to be called from ode45. The';
comments{5} = '    model allows for arbitrary mass and inertia for each';
comments{6} = '    link, but no friction or actuation';
comments{7} = ' ';
comments{8}  = 'INPUTS: ';
comments{9}  = '    t = time. Dummy input for ode45. Not used.';
comments{10} = '    z = [4xn] matrix of states.';
comments{12} = '    P = struct of parameters';
comments{13} = 'OUTPUTS: ';
comments{14} = '    dz = [4xn] matrix of state derivatives';
comments{15} = ' ';
comments{16} = 'NOTES:';
comments{17} = ['    This file was automatically generated by ' mfilename]; 

params{1} = {'m1','link one mass'};
params{2} = {'m2','link two mass'};
params{3} = {'g ','gravity'};
params{4} = {'l1','link one length'};
params{5} = {'l2','link two length'};
params{6} = {'I1','link one moment of inertia about its center of mass'};
params{7} = {'I2','link two moment of inertia about its center of mass'};
params{8} = {'d1','distance between link one center of mass and parent joint'};
params{9} = {'d2','distance between link two center of mass and parent joint'};

states{1} = {'th1','link one absolute angle'};
states{2} = {'dth1','link one angular rate'};
states{3} = {'th2','link two absolute angle'};
states{4} = {'dth2','link two angular rate'};

dstates{1} = {'dth1','derivative of link one absolute angle'};
dstates{2} = {'ddth1','derivative of link one angular rate'};
dstates{3} = {'dth2','derivative of link two absolute angle'};
dstates{4} = {'ddth2','derivative of link two angular rate'};

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                               write file                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
fid = fopen([filename '.m'],'w');

fprintf(fid, ['function dz = ' filename '(~,z,P) \n']);

for i=1:length(comments)
    fprintf(fid,['%%' comments{i} '\n']);
end
fprintf(fid,'\n');

for i=1:length(params)
    fprintf(fid,[params{i}{1} ' = P.' params{i}{1} '; %%' params{i}{2} '\n']);
end
fprintf(fid,'\n');

for i=1:length(states)
    fprintf(fid,[states{i}{1} ' = z(' num2str(i) ',:); %%' states{i}{2} '\n']);
end
fprintf(fid,'\n');

for i=1:2;
    fprintf(fid,['f' num2str(i) ' = ' vectorize(char(f(i))) ';\n']);
end
fprintf(fid,'\n');

for i=1:2
    for j=1:2
        fprintf(fid,['M' num2str(i) num2str(j) ' = ' vectorize(char(M(i,j))) ';\n']);
    end
end
fprintf(fid,'\n');

fprintf(fid,'D = M11.*M22 - M12.*M21;\n\n');

fprintf(fid,'ddth1 = (f2.*M12 - f1.*M22)./D;\n');
fprintf(fid,'ddth2 = -(f2.*M11 - f1.*M21)./D;\n');
fprintf(fid,'\n');

fprintf(fid,'dz = [...\n');
for i=1:length(dstates)
    fprintf(fid,['    ' dstates{i}{1} '; %%' dstates{i}{2} '\n']);
end
fprintf(fid,'];\n');

fprintf(fid,'end \n');

fclose(fid);
end


