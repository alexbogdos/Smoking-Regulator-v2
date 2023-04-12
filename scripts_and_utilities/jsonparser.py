import json


class SmokingRegulatorParser:
    def __init__(self, path: str, export_path: str = "data.csv") -> None:
        self.path: str = path
        self.export_path = export_path
        self.raw_data: dict = self.load()
        self.folder_path: str = self.get_local_path()

    def get_local_path(self):
        if self.path.count('/') > 0:
            dirs = self.path.split('/')
            path = ""
            for d in dirs[0:-1]:
                path += f"{d}/"
            return path

    def load(self) -> dict:
        with open(self.path, 'r') as file:
            return json.load(file)

    def print_iterable(self, iterable):
        for item in iterable:
            print(item)

    def export(self, data: list):
        with open(self.export_path, 'w') as file:
            file.writelines(data)


class SettingsParser(SmokingRegulatorParser):
    def __init__(self, path: str) -> None:
        super().__init__(path)
        self.settings: dict = self.raw_data.items()

    def print_settings(self):
        self.print_iterable(self.settings)

    def get_settings(self):
        data = []
        for item in self.settings:
            setting_name = item[0]
            settings_value = item[1]
            row = f'{setting_name}, {settings_value}\n'
            data.append(row)
        return data

    def export_settings(self):
        settings = self.get_settings()
        self.export(settings)

    def export(self, data: list):
        self.export_path = "UserSettings.csv"
        data.insert(0, "Setting, Value\n")
        return super().export(data)


class DataParser(SmokingRegulatorParser):
    def __init__(self, path: str) -> None:
        super().__init__(path)
        self.weeks: dict = self.raw_data.values()
        self.days: dict = [day for week in self.weeks for day in week.values()]

    def print_weeks(self):
        self.print_iterable(self.weeks)

    def print_days(self):
        self.print_iterable(self.days)

    # ----- Time Table --------------------
    def get_close(self, time: str) -> str:
        hour, minute = time.split(":")[0], time.split(":")[1]

        if (minute < '30'):
            return f"{hour}:00"
        else:
            return f"{hour}:30"

    def get_day_timeslices(self, day: dict):
        time_stamps = []
        for timeslice in day["Time Table"]:
            time_stamps.append(self.get_close(timeslice))
        return time_stamps

    def hourToString(self, hour):
        if (hour < 10):
            return f"0{hour}"
        else:
            return hour

    def generate_timeslots(self):
        time_slots: dict = {}
        for hour in range(0, 24):
            time_slots[f"{self.hourToString(hour)}:00"] = 0
            time_slots[f"{self.hourToString(hour)}:30"] = 0
        return time_slots

    def get_timetable(self):
        time_slots = self.generate_timeslots()

        for day in self.days:
            time_slices = self.get_day_timeslices(day)
            for ts in time_slices:
                time_slots[ts] += 1

        data = []
        for slot in time_slots.items():
            row = f'{slot[0]}, {slot[1]}\n'
            data.append(row)

        return data

    # ----- Day Data --------------------
    def get_counts(self):
        data = []
        for day in self.days:
            row = f'{day["Week Group"]}, {day["Day"]}, {day["Date"]}, {day["Count"]}\n'
            data.append(row)

        return data

    # ----- Export --------------------
    def export_counts(self, data: list):
        data.insert(0, "Week Group, Day, Date, Count\n")
        self.export_path = "UserData-Counts.csv"
        super().export(data)

    def export_timetable(self, data: list):
        data.insert(0, "Time, Count\n")
        self.export_path = "UserData-TimeTable.csv"
        super().export(data)

    def export_data(self):
        counts = self.get_counts()
        self.export_counts(counts)

        timetable = self.get_timetable()
        self.export_timetable(timetable)


def readPath(name: str, default: str = ""):
    path = input(f"Path to {name}: ")
    if path == "" and default != "":
        return default
    else:
        return path


if __name__ == "__main__":
    settings_path = readPath("Settings", default='/home/shollow/Documents/Smoking Regulator/usersetting.json')
    settings_parser = SettingsParser(settings_path)
    settings_parser.export_settings()

    data_path = readPath("Data", default='/home/shollow/Documents/Smoking Regulator/userdata.json')
    data_parser = DataParser(data_path)
    data_parser.export_data()
