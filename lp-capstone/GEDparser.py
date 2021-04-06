ged = open("tree.ged", 'r')
out = open("tree.pl", 'w')

word = [ ]
people = [ ]
person = {'UID': '', 'Name': '', 'Surname': ''}
for line in ged:
    word = line.rstrip("\n").split(' ')
    if word[1][1] == 'F':
        people.append(person)
        break
    if word[0] == '0' and word[1][:2] == "@I":
        people.append(person)
        person = {'UID': '', 'Name': '', 'Surname': ''}
        person['UID'] =  word[1]
    elif word[1] == 'GIVN':
        person['Name'] = word[2]
    elif word[1] == 'SURN':
        person['Surname'] = word[2]

del(people[0]) #When we read the first id, we append empty dictionary. Deleting it...

father = "NO_DATA"
mother = "NO_DATA"
kids = ["NO_DATA"]
for line in ged:
    word = line.rstrip("\n").split(' ')
    if word[0] == '0':
        for child in kids:
            out.write("parents(\'" + child + "\',\'" + father + "\',\'" + mother + "\').\n")
        father = "NO_DATA"
        mother = "NO_DATA"
        kids = ["NO_DATA"]

    elif word[1] == "HUSB":
        for person in people:
            if word[2] == person['UID']:
                father = person['Name'] + ' ' + person['Surname']
                break
    elif word[1] == "WIFE":
        for person in people:
            if word[2] == person['UID']:
                mother = person['Name'] + ' ' + person['Surname']
                break
    elif word[1] == "CHIL":
        for person in people:
            if word[2] == person['UID']:
                if kids[0] == "NO_DATA":
                    kids[0] = person['Name'] + ' ' + person['Surname']
                    break
                else:
                    kids.append(person['Name'] + ' ' + person['Surname'])
                    break

ged.close()
out.close()