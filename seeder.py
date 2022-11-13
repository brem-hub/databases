import peewee
import os
import country_list
import random
import sys
import logging
import string
import datetime

DEFAULT_NUMBER_OF_ENTITIES = 10

PLAYER_CONST = 20

EVENTS_CONST = 100

db = peewee.PostgresqlDatabase(
    user=os.getenv('PGUSER', 'KULIKOV_204'), 
    database=os.getenv('PGDATABASE', 'KULIKOV_204'),
    password=os.getenv('PGPASSWORD', 'KULIKOV_204'),
    host=os.getenv('PGHOST', 'localhost'),
    port=os.getenv('PGPORT', '5430')
)


class Country(peewee.Model):
    class Meta:
        database = db
        db_table = 'countries'

    country_id = peewee.CharField(3, primary_key=True)

    name = peewee.CharField(40)

    area_sqkm = peewee.IntegerField()

    population = peewee.IntegerField()


class Olympic(peewee.Model):
    class Meta:
        database = db
        db_table = 'olympics'

    olympic_id = peewee.CharField(7, primary_key=True)

    country_id = peewee.ForeignKeyField(Country, to_field='country_id')

    city = peewee.CharField(30)

    year = peewee.IntegerField()

    startdate = peewee.DateField()

    enddate = peewee.DateField()


class Event(peewee.Model):
    class Meta:
        database = db
        db_table = 'events'
    
    event_id = peewee.CharField(7, primary_key=True)

    name = peewee.CharField(40)

    eventtype = peewee.CharField(20)

    olympic_id = peewee.ForeignKeyField(Olympic, to_field='olympic_id')

    is_team_event = peewee.IntegerField(choices=[0, 1])

    num_players_in_team = peewee.IntegerField()

    result_noted_in = peewee.CharField(100)


class Player(peewee.Model):
    class Meta:
        database = db
        db_table = 'players'

    player_id = peewee.CharField(100, primary_key=True)

    name = peewee.CharField(40)

    country_id = peewee.ForeignKeyField(Country, to_field='country_id')

    birthdate = peewee.DateField()


class Result(peewee.Model):
    class Meta:
        database = db
        db_table = 'results'
        primary_key=peewee.CompositeKey('event_id', 'player_id')
    
    event_id = peewee.ForeignKeyField(Event, to_field='event_id')

    player_id = peewee.ForeignKeyField(Player, to_field='player_id')

    medal = peewee.CharField(7)

    result = peewee.DoubleField()


db.connect()

def get_country() -> str:
    return random.choice(
        list(
            dict(
                country_list.countries_for_language(lang='en')
            ).values()
        )
    )


def random_string(n: int = 10) -> str:
    return ''.join(random.choice(string.ascii_lowercase) for i in range(n))



def seed_table(number_of_entities: int):
    """
    Seed table generates dummy data to fill database with.
    
    Params:
        number_of_entities: int - number of entities to create.
    """

    assert number_of_entities > 0 or 'Number of entities must be non-negative'

    # Initially, create countries.

    countries: list[dict] = []
    for country_idx in range(number_of_entities):
        country_params = {
            'country_id': country_idx,
            'name': get_country(),
            'area_sqkm': random.randint(10e3, 10e8),
            'population': random.randint(10e6, 10e8)
        }
        
        Country.create(**country_params)

        countries.append(country_params)


    players: list[dict] = []
    for player_idx in range(random.randint(number_of_entities, number_of_entities * PLAYER_CONST)):
        player_params = {
            'player_id': player_idx,
            'name': random_string(),
            'country_id': random.choice(countries)['country_id'],
            # get random date from 1910-01-01 to 2000-01-01.
            'birthdate': datetime.datetime.utcfromtimestamp(random.randint(-1893465017, 946674000)).strftime('%Y-%m-%d')
        }
        Player.create(**player_params)
        players.append(player_params)

    olympics: list[dict] = []
    for olympic_idx in range(1936, 2024, 4):

        start_month = random.randint(1, 9)
        end_month = random.randint(start_month + 1, 12)

        olympic_params = {
            'olympic_id': olympic_idx,
            'country_id': random.choice(countries)['country_id'],
            'city': random_string(),
            'year': olympic_idx,
            'startdate': f'{olympic_idx}-{start_month}-{random.randint(1, 30)}',
            'enddate': f'{olympic_idx}-{end_month}-{random.randint(1, 30)}'
        }
        Olympic.create(**olympic_params)
        olympics.append(olympic_params)
    
    
    events: list[dict] = []
    for event_idx in range(number_of_entites, number_of_entities * EVENTS_CONST):
        event_params = {
            'event_id': event_idx,
            'name': random_string(),
            'eventtype': random_string(),
            'olympic_id': random.choice(olympics)['olympic_id'],
            'is_team_event': random.choice([0, 1]),
            'num_players_in_team': random.randint(1, 10),
            'result_noted_in': random_string(50),
        }

        Event.create(**event_params)

        events.append(event_params)

    def choose_alive_player(event) -> dict:
        data: Olympic = Olympic.get(event['olympic_id'])
        while True:
             player = random.choice(players)
             if int(player['birthdate'][:4]) + 15 < int(data.year):
                return player

    results: list[dict] = []
    for event_idx in range(number_of_entites):
        result_params = {
            'event_id': (event := random.choice(events))['event_id'],
            'player_id': choose_alive_player(event)['player_id'],
            'medal': random.choice(['GOLD', 'SILVER', 'BRONZE']),
            'result': random.random() * random.randint(3, 10e5),
        }
        Result.create(**result_params)
        results.append(result_params)


def clear_tables():
    Event.truncate_table(cascade=True)
    Result.truncate_table(cascade=True)
    Country.truncate_table(cascade=True)
    Player.truncate_table(cascade=True)
    Olympic.truncate_table(cascade=True)


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    
    number_of_entites = int(os.getenv("NUMBER_OF_ENTITIES", DEFAULT_NUMBER_OF_ENTITIES))

    if len(sys.argv) == 1:
        logging.warning(f'using default number of entities {number_of_entites}')
    else:
        number_of_entities = int(sys.argv[1])
        logging.info(f'using number of entities equal to {number_of_entities}')
    
    clear_tables()

    seed_table(number_of_entities=number_of_entites)