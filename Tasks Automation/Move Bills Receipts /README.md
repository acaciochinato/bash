# Move Bills Receipts 

This script is aimed to automate the boring task of saving bill receipts every month in a pre-defined location. It basically checks if the destination folder is accessible and if it is, will check if the Bill and year directory is created, if not, it will create the necessary folders and the file will be copied into it renaming to the name of the month that the script was executed.

The structure of the destination folder is like this:

```
/destination/folder
├── Bill
│   ├── 2024
│   │   ├── 01.January.png
│   │   ├── 02.February.jpeg
│   │   ├── 03.March.jpeg
│   │   ├── 04.April.jpeg
│   │   ├── 06.June.jpeg
│   │   ├── 07.July.jpeg
│   │   ├── 09.September.png
│   │   ├── 11.November.png
│   │   └── 12.December.png
```
And for the source folder, the script expects to be like this:

```
/home/Downloads/receipts
├── Bill_1
│   └── bill.png
├── Bill_2
├── Bill_3
│   └── bill.png
```

There's no need to create this folders structures, just point to the root destination folder and the script will automatically create it providing the necessary folders. Also, if there's more than one file in a bill folder, the script will ignore that Bill and jump to the next one.