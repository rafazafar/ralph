set -e

if [ -z "$1" ]; then
    echo "Usage: ralph <iterations>"
    exit 1
fi

AI_DIR=".ai"

# Check if .ai directory exists
if [ ! -d "$AI_DIR" ]; then
    echo "Error: '$AI_DIR' directory not found. Are you in the correct repo root?"
    exit 1
fi

PRD_FILE="$AI_DIR/prd.json"
PROGRESS_FILE="$AI_DIR/progress.txt"

# Check if required files exist
if [ ! -f "$PRD_FILE" ]; then
    echo "Error: '$PRD_FILE' not found"
    exit 1
fi

for ((i=1; i<=$1; i++)); do 
    echo "Iteration $i" 
    echo "--------------------------------" 
    result=$(ccg -p "@$PRD_FILE @$PROGRESS_FILE \
1. Find the highest-priority feature to work on and work only on that feature. \
This should be the one YOU decide has the highest priority - not necessarily the first. \
2. Check that the types check via popm typecheck and that the tests pass via ppm test. \
3. Update the PRD with the work that was done. \
4. Append your progress to the progress.txt file. \
Use this to leave a note for the next person working in the codebase. \
5. Make a git commit of that feature. \
ONLY WORK ON A SINGLE FEATURE. \
If, while implementing the feature, you notice the PRD is complete, output ‹promise>COMPLETE</promise> \
")

    echo "$result"

    if [[ "$result" == *"‹promise>COMPLETE</promise>"* ]]; then 
        echo "PRD complete, exiting."
        exit 0
    fi
done