function parsim_repmat = scenario_repmat(nowseries, model)

parsim_repmat=repmat(Simulink.SimulationInput,[1 size(nowseries, 1)]);
for i = 1:size(nowseries,1)
    scenario = add_scenario(nowseries(i,:));
    parsim_repmat(i) = Simulink.SimulationInput(model);  %模型名称
%     parsim_repmat(i) = parsim_repmat(i).setVariable('scenario',scenario);
    parsim_repmat(i) = parsim_repmat(i).setVariable('scenario',scenario);
    parsim_repmat(i) = setPreSimFcn(parsim_repmat(i), @assignScenario);
end

end

