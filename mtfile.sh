while getopts fdl opt; do
      case $opt in
            f) 
                  echo "got f"
                  ;;
            d) 
                  echo "got d"
                  ;;
            l) echo "got l"
               ;;
      esac
done
