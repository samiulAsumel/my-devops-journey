#!/bin/bash

mkdir -p ~/techcorp-process-monitor/{bin,config,logs,reports}
cd ~/techcorp-process-monitor

touch bin/process-health-check.sh
touch bin/resource-alert.sh
touch bin/process-manager.sh


echo "#!/bin/bash" > bin/process-health-check.sh
echo "#!/bin/bash" > bin/resource-alert.sh
echo "#!/bin/bash" > bin/process-manager.sh
chmod +x bin/*.sh


echo "TechCorp directory structure for process monitoring created successfully."
